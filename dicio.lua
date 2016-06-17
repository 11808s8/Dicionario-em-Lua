#!/usr/bin/env lua


function mostraTela(esp, port) -- Função que mostra o conteúdo na tela
	repeat
	os.execute('reset') -- limpa a tela
	print("Contéudo do dicionário:")
	
	for k,v in ipairs(esp) do
		print(v .. " - " .. port[k])
	end

	escolha = retornaMenu()
	until escolha=='S'
end



function menuIncluirPalavra(esp,port) -- Menu relacionado a inclusão de palavras
	repeat
		os.execute('reset') -- limpa a tela
		local palavraEsp,significadoPort,certeza = 'N'
		repeat	
			print("Digite a palavra (em espanhol) que deseja inserir:")
			palavraEsp = io.read()
			print("\nTem certeza que deseja inserir essa palavra: \n\t\t\t" .. palavraEsp .. "? (s/n)")
			certeza = string.upper(io.read())
		until certeza == 'S'
		repeat
			print("Digite o significado (em Português) da palavra:")
			significadoPort = io.read()
			print("\nTem certeza que este é o significado que deseja inserir? (s/n)")
			print(significadoPort)
			certeza = string.upper(io.read())
		until certeza == 'S'
			insereOrdenado(esp,port,palavraEsp,significadoPort)
			print("\nPronto, palavra inserida com sucesso!")
		escolha = retornaMenu()
	until escolha =='S'
end



function insereOrdenado(esp,port,palavraEsp,significadoPort)
	aux =  string.lower(palavraEsp)
	tamanhoTabela = #esp
	if(tamanhoTabela==0)then
		esp[1] = palavraEsp
		port[1] = significadoPort
		return
	end
	i=1
	while i <= tamanhoTabela do
		if( string.lower(esp[i]) > aux) then
			break
		end
		i = i + 1
	end

	j = tamanhoTabela + 1
	while j >= i do
		esp[j] = esp[j-1]
		port[j] = port[j-1]
		j = j-1
	end

	esp[i] = palavraEsp
	port[i] = significadoPort

end

function pesquisaPalavra(esp,port) -- Função que chama a função genérica de pesquisa
	
	local pesquisa, palavra
	repeat
		os.execute('reset')
		print("Digite qual palavra você gostaria de pesquisar:")
		palavra = io.read()
		pesquisaGenerica(esp,port,'P', palavra)
		pesquisa = retornaMenu()
	until pesquisa=='S'
	

end

function exclui(esp,port) -- Função que chama a função genérica de pesquisa para exclusão
	local excluir
	repeat
		os.execute('reset')
		print("Digite qual palavra você gostaria de excluir:")
		palavra = io.read()
		pesquisaGenerica(esp,port,'E', palavra)	
		pesquisa = retornaMenu()
	until pesquisa=='S'
end

function alterarSignificado(esp,port) -- Função que chama a função genérica de pesquisa para alterar o significado
	local alterar
	repeat
		os.execute('reset')
		print("Digite qual palavra você gostaria de alterar o significado:")
		palavra = io.read()
		pesquisaGenerica(esp,port,'A', palavra)	
		pesquisa = retornaMenu()
	until pesquisa=='S'	

end

function pesquisaGenerica(esp,port,PEA, palavra) -- Função com a Parte genérica das pesquisas que ao encontrar a palavra: 'P'esquisa (exibe na tela), 'E'xclui a palavra, 'A'ltera o significado da palavra
	inicialP = string.sub(palavra,1,1)	 -- Se ela for encontrada, senão, com todas as três opções, retorna que não encontrou e envia para as funções que a chamaram.
		tamTabela = #esp
		i = 1
		while((string.sub(esp[i],1,1) ~= inicialP) and i<tamTabela) do
			i = i + 1
		end
		if(string.sub(esp[i],1,1) == inicialP) then
			while((esp[i]~= palavra) and i<=tamTabela) do
				i = i + 1
			end
			if(esp[i]==palavra) then
				if(PEA=='P') then
					print("\tPalavra em espanhol:" .. esp[i] .. "\n\tSignificado em Português:" .. port[i])
					print()
				elseif(PEA=='E') then
					table.remove(esp,i)
					table.remove(port,i)
					print("Pronto, palavra e significado removidos!")
				else
					local significado
					repeat
						print("Palavra encontrada. Seu significado atual é\n\t" .. port[i])
						print("Digite o novo significado:")
						significado = io.read() 
						print("Tem certeza que esse é o significado que deseja inserir?(s/n)")
						local certeza = io.read()
					until certeza == 's'
					port[i] = significado
					print()
					print("Pronto, significado alterado!")
					print()
				end
			else
				print("Palavra não encontrada!")
			end
		else
			print("Palavra não encontrada!")
		end
end

function exportaconteudo(esp,port,lerCriar,Nome)	-- Função que exporta o conteúdo para um arquivo .csv
	os.execute('reset') -- limpa a tela
	local escolha = '0', nome	
	if lerCriar=='l' then
		print("Desejas gravar o conteúdo no mesmo arquivo que está aberto? (s/n)")
		escolha = string.lower(io.read())
	end
	
	if escolha~='s' then	
		print("Digite o nome do arquivo que deseja criar:")
		Nome = io.read()
	end
	Nome = Nome .. '.csv'
	local file = io.open(Nome,"w")		-- Sempre irá limpar o arquivo e adicionar as palavras novas/mesmas ordenadamente
	io.output(file)
	
	local linha
	local i
	i = 1
	local tamTabela
	tamTabela = #esp
	print(i)
	while i<=tamTabela do
		linha = esp[i] .. "," .. port[i]
		io.write(linha .. "\n")
		i = i+1
	end
	io.close(file)
	io.output()
	print("Pronto, arquivo " .. Nome .. " criado. Retornando ao menu. (enter)")
	io.read()
	return Nome	-- Retorna o nome com .csv concatenado
end

function leArq(esp,port,Nome)

	local aux, linha, tamLinha, i ,flag, palavraEsp,significadoPort, file, c
	file =  assert(io.open(Nome .. ".csv","r"))     -- Se não encontra o arquivo, retorna erro.
		for linha in file:lines() do			-- Para cada linha, fará o tratamento.
			
			aux = ""
			tamLinha = #linha
			i = 1
			flag = 0
			while i<tamLinha do
				c = string.sub(linha,i,i)
				if(i==1 and c=="") then		-- Se na primeira letra encontrar um espaço, quebra e ativa a flag que...\/
					flag = 1										      -- ||
					break											      -- ||
				end												      -- ||
				if(c==",") then 		-- Se encontrar vírgula, quebra					      -- ||
					break											      -- ||
				end												      -- ||
																      -- ||
															 	      -- ||
				aux = aux .. c											      -- ||
				i = i + 1											      -- ||
			end													      -- \/
			if(flag~=1) then									-- Não deixa entrar nesse loop, fazendo-o passar para a próxima linha (caso tenha espaço no 															--	arquivo)
				i = i+1
				palavraEsp = aux
				aux = ""
			
				while i<=tamLinha do
					aux = aux .. string.sub(linha,i,i)
					i = i +1
				end
				significadoPort = aux

				insereOrdenado(esp,port,palavraEsp,significadoPort)

			end
		end
		
		--[[local lower1, lower2
		i=1
		while i<contadorPalavras do
			lower1 = string.lower(esp[i]) -- Para comparar ambas as palavras são colocadas em lowercase, pois, sem isso, tinha um comportamento estranho
			while j<contadorPalavras  do
				lower2 = string.lower(esp[j])

				if(lower1<lower2) then -- Ordena a tabela de palavras em esp(anhol) e o significado na tabela port(uguês); Mantém seus índices iguais
					aux = esp[i]											-- Para manter linkado palavra e significado
					esp[i] = esp[j]
					esp[j] = aux

					aux = port[i]
					port[i]	= port[j]
					port[j] = aux
				end
				j = j + 1
			end
		i = i + 1
		j = 1
		end--]]



	
	io.close(file)					-- Fecha o arquivo, pois já leu as palavras e colocou-as nas tabelas.
	return true

end


function retornaMenu() -- Função para retornar ao menu principal

	print("Deseja voltar ao menu?(S/N)")
	escolha = string.upper(io.read())
	return escolha
	
end

function menuLeArq(esp,port,Nome)
	
	repeat
		os.execute('reset') -- limpa a tela
		io.write('\n Digite o nome do arquivo que deseja')
		io.write(' ler:\n')
		Nome = io.read()
		print("Tem certeza de que esse é o nome do arquivo?(s/n)")
		certeza = string.lower(io.read())
	until certeza == 's'
	leArq(esp,port,Nome)
	
	return Nome

end


								--- Corpo principal do programa ---

repeat 			-- loop principal do programa
	local escolha,lerCriar,Nome, file, linha, c, abriuArq = false  -- declaração de variáveis locais

	repeat							--LOOP
		os.execute('reset') -- limpa a tela

		print('\n Você deseja criar um novo arquivo .CSV ou ler um existente?(c/l)\n (Não é necessário especificar a extensão, pois .csv é o padrão permanente).')
		lerCriar = string.lower(io.read())

		
		

		if lerCriar == 'c' then
			io.write(' Tudo bem! Você pode criar um arquivo (opção 6 no menu)\n logo após adicionar algum conteúdo ao dicionário.\n')

		elseif lerCriar ~='l' and lerCriar ~= 'c' then
			io.write('Você digitou uma opção inválida. Tente novamente. (enter)\n')
			io.read()
		end
	until lerCriar=='l' or lerCriar=='c'			--FIM_LOOP
		

	
	
	local port = {}
	local esp = {}
	local flag
	local contadorPalavras = 0
	local j=1
	local palavraEsp, significadoPort, certeza
	

	if(lerCriar=='l') then					-- LEITURA DO ARQUIVO
		repeat
			io.write('\n Digite o nome do arquivo que deseja')
			io.write(' ler:\n')
			Nome = io.read()
			print("Tem certeza de que esse é o nome do arquivo?(s/n)")
			certeza = string.lower(io.read())
		until certeza == 's'
		abriuArq = leArq(esp,port,Nome)
	end	
	
		local voltou = false

	repeat 												-- LOOP DO MENU PRINCIPAL
		os.execute('reset') -- limpa a tela

		print('\t\t ============================= ')
		print('\t\t|Dicionário Português-Espanhol|')
		print('\t\t|p/ aula do Martinotto\t      |')
		print('\t\t ============================= ')
		if abriuArq == true then 
			io.write('\n\t\t Nome do Arquivo aberto: '.. Nome ) 
			if voltou == false then 
				io.write(".csv\n") 
			else 	
				io.write("\n") 
			end 
		end
		print('\n\t ________________________________________________________')
		print('\t|Escolha a opção digitando o número e dando enter ')
		print('\t| 1 -- Incluir uma palavra nova (e seu significado) ')
		print('\t| 2 -- Pesquisa por uma palavra em espanhol')
		print('\t| 3 -- Alterar o significado de alguma palavra')
		print('\t| 4 -- Excluir palavras do dicionário')
		print('\t| 5 -- Listagem de todo o conteúdo do dicionário')
		print('\t| 6 -- Exportar conteúdo do dicionário para um arquivo .csv')
		print('\t| 7 -- Abre outro arquivo .csv')
		print('\t| 0 -- Para sair do Programa\n')
		escolha = io.read()
		if(escolha=='1') then
			menuIncluirPalavra(esp,port)
		elseif(escolha == '2') then
			pesquisaPalavra(esp,port)
		elseif(escolha == '3') then
			alterarSignificado(esp,port)
		elseif(escolha == '4') then
			exclui(esp,port)
		elseif(escolha=='5') then
			mostraTela(esp, port)
		elseif(escolha=='6') then
			Nome = exportaconteudo(esp,port,lerCriar,Nome)
			voltou = true
			abriuArq = true
		elseif(escolha=='7') then
			Nome = menuLeArq(esp,port,Nome)
			abriuArq = true
			io.output()
			io.input()
		end	
			
	
	until escolha=='0'										-- FIM_LOOP
	os.execute('reset')
until escolha=='0'					-- FIM_LOOP
