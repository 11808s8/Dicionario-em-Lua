#!/usr/bin/env lua


function mostraTela(esp, port) -- Função que mostra o conteúdo na tela
	repeat
	os.execute('reset') -- limpa a tela
	print("Contéudo do dicionário:")
	
	for k,v in ipairs(esp) do -- itera até o final do array esp, trazendo os valores de cada par do array esp
		print(v .. " - " .. port[k]) -- Com o mesmo índice do array esp, estão ordenados os significados, facilitando a visualização.
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
			print("\t\t" .. significadoPort)
			certeza = string.upper(io.read())
		until certeza == 'S'
			insereOrdenado(esp,port,palavraEsp,significadoPort) -- Insere ordenado a palavra em espanhol e o significado em português.
			print("\nPronto, palavra inserida com sucesso!")
		escolha = retornaMenu() -- Se não deseja retornar ao menu, realiza o processo novamente.
	until escolha =='S'
end



function insereOrdenado(esp,port,palavraEsp,significadoPort) -- Inserção ordenada. Não faz a verificação se a palavra já existe, apenas insere.
	aux =  string.lower(palavraEsp)
	tamanhoTabela = #esp
	if(tamanhoTabela==0)then -- Se a lista está vazia, insere no primeiro índice
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
		pesquisaGenerica(esp,port,'P', palavra) -- Se não encontra, retorna mensagem de erro na própria função
		pesquisa = retornaMenu()
	until pesquisa=='S'
	

end

function exclui(esp,port) -- Função que chama a função genérica de pesquisa para exclusão
	local excluir
	repeat
		os.execute('reset')
		print("Digite qual palavra você gostaria de excluir:")
		palavra = io.read()
		pesquisaGenerica(esp,port,'E', palavra)	-- Se não encontra, retorna mensagem de erro na própria função
		pesquisa = retornaMenu()
	until pesquisa=='S'
end

function alterarSignificado(esp,port) -- Função que chama a função genérica de pesquisa para alterar o significado
	local alterar
	repeat
		os.execute('reset')
		print("Digite qual palavra você gostaria de alterar o significado:")
		palavra = io.read()
		pesquisaGenerica(esp,port,'A', palavra)	-- Se não encontra a palavra, retorna mensagem de erro na própria função
		pesquisa = retornaMenu()
	until pesquisa=='S'	

end

function pesquisaGenerica(esp,port,PEA, palavra) -- Função com a Parte genérica das pesquisas que ao encontrar a palavra: 'P'esquisa (exibe na tela), 'E'xclui a palavra, 'A'ltera o significado da palavra
	inicialP = string.sub(palavra,1,1)	 -- Se ela for encontrada, senão, com todas as três opções, retorna que não encontrou e envia para as funções que a chamaram.
		tamTabela = #esp
		i = 1
		if tamTabela == 0 then -- Se o dicionário está vazio, não prosseguir com operações
			print("Dicionário vazio! Favor insira alguma palavra para poder \nprosseguir com as operações desta opção. Obrigado!") 
			return
		end
		while(i<tamTabela and (string.sub(esp[i],1,1) ~= inicialP)) do -- Itera até encontrar inicial ou chegar ao final da tabela
			i = i + 1
		end
		if(string.sub(esp[i],1,1) == inicialP) then -- Se "i" parou na inicial correta, prossegue, senão, exibe mensagem de erro.
			while((esp[i]~= palavra) and i<=tamTabela) do
				i = i + 1
			end
			if(esp[i]==palavra) then -- Se encontrou a palavra, executa.
				if(PEA=='P') then -- Se for apenas pesquisa...
					print("\tPalavra em espanhol:" .. esp[i] .. "\n\tSignificado em Português:" .. port[i])
					print()
				elseif(PEA=='E') then -- Se for exclusão de palavra...
					table.remove(esp,i)
					table.remove(port,i)
					print("Pronto, palavra e significado removidos!")
				else		      -- Senão, é alteração de significado.
					local significado
					repeat
						print("Palavra encontrada. Seu significado atual é\n\t" .. port[i])
						print("Digite o novo significado:")
						significado = io.read() 
						print("Tem certeza que esse é o significado que deseja inserir?(s/n)")
						local certeza = io.read()
					until certeza == 's'
					port[i] = significado -- Sobrescreve o significado já existente com o que acabou de ser inserido
					print()
					print("Pronto, significado alterado!")
					print()
				end
			else -- Senão, retorna que não encontrou.
				print("Palavra não encontrada!")
			end
		else
			print("Palavra não encontrada!")
		end
end

function exportaconteudo(esp,port,lerCriar,Nome)	-- Função que exporta o conteúdo para um arquivo .csv
	os.execute('reset') -- limpa a tela
	local escolha = '0', nome	
	local temp = io.output()	-- atribui a uma variável o output padrão, que é o stdin
	if lerCriar=='l' then		-- verifica se o usuário já está lendo de outro arquivo
		print("Desejas gravar o conteúdo no mesmo arquivo que está aberto? (s/n)") -- Se arquivo já está aberto, pergunta.
		escolha = string.lower(io.read())
	end
	
	if escolha~='s' then	
		print("Digite o nome do arquivo que deseja criar (Por favor omita o .csv pois ele será incluso automaticamente):")
		Nome = io.read()
	end
	Nome = Nome .. '.csv'			-- concatena .csv no nome do arquivo
	local file = io.open(Nome,"w")		-- Sempre irá limpar o arquivo e adicionar as palavras novas/mesmas ordenadamente
	io.output(file)				-- Coloca como output o arquivo lido
	
	local linha
	local i
	i = 1
	local tamTabela
	tamTabela = #esp
	while i<=tamTabela do
		linha = esp[i] .. "," .. port[i]
		io.write(linha .. "\n")
		i = i+1
	end
	io.close(file) -- fecha o arquivo
	io.output(temp) -- seta o output novamente como o padrão
	io.write("\nPronto, arquivo " .. Nome )
	if escolha ~= 's' then
	 	io.write(" criado.")
	else
		io.write(" atualizado.")
	end
	io.write("Retornando ao menu. (enter)")
	io.read()
	return Nome	-- Retorna o nome com .csv concatenado
end

function leArq(esp,port,Nome)

	local aux, linha, tamLinha, i ,flag, palavraEsp,significadoPort, file, c
	
	file =  assert(io.open(Nome .. ".csv","r"))     -- Se não encontra o arquivo, retorna erro e o programa fecha.
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
				aux = aux .. c			-- Concatena a string auxiliar com o caractere que acabou de ler      -- ||
				i = i + 1											      -- ||
			end													      -- \/
			if(flag~=1) then						-- Não deixa entrar nesse loop, fazendo-o passar para a próxima linha (caso tenha espaço no 												--	arquivo)
				i = i+1
				palavraEsp = aux -- Copia a palavra em espanhol para a variável que será inserida na função insere Ordenado
				aux = "" -- esvazia a string aux
			
				while i<=tamLinha do -- copia o conteúdo enquanto i for menor que o tamanho final da linha.
					aux = aux .. string.sub(linha,i,i) -- copia caracter por caracter
					i = i +1
				end
				significadoPort = aux -- copia o significado de aux para a variável que será inserida na função insere Ordenado

				insereOrdenado(esp,port,palavraEsp,significadoPort) -- Chama a função Insere Ordenado

			end
		end

	
	io.close(file)					-- Fecha o arquivo, pois já leu as palavras e colocou-as nas tabelas.
	return true					-- Retorna verdadeiro pois conseguiu abrir

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


	local i, tamTabela
	i = 1
	tamTabela = #esp
	while i<=tamTabela do -- Esvazia as listas de palavras e significados antes de ler.
		esp[i] = nil
		port[i] = nil
		i = i + 1
	end
	
	leArq(esp,port,Nome)
	
	return Nome

end


local port = {}
local esp = {}

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
			lerCriar = 'l'
			voltou = true
			abriuArq = true
		elseif(escolha=='7') then
			Nome = menuLeArq(esp,port,Nome,lerCriar)
			lerCriar = 'l'
			abriuArq = true
		end	
			
	
	until escolha=='0'										-- FIM_LOOP
	os.execute('reset')
until escolha=='0'					-- FIM_LOOP
