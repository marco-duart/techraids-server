def attach_random_image(record, dir, files, attachment_name = :image)
  return if files.empty?
  image_path = dir.join(files.sample)
  file = File.open(image_path)
  record.send(attachment_name).attach(io: file, filename: File.basename(image_path))
  file.close
end

# Pontos do Mapa
points_file = Rails.root.join('db', 'seeds', 'json', 'points.json')
points = JSON.parse(File.read(points_file))

# Imagens
MALE_CHARACTER_CLASS_IMAGES_DIR = Rails.root.join('db', 'seeds', 'images', 'character_class', 'male')
FEMALE_CHARACTER_CLASS_IMAGES_DIR = Rails.root.join('db', 'seeds', 'images', 'character_class', 'female')
BOSS_IMAGES_DIR = Rails.root.join('db', 'seeds', 'images', 'boss')
male_character_class_image_files = Dir.children(MALE_CHARACTER_CLASS_IMAGES_DIR)
female_character_class_image_files = Dir.children(FEMALE_CHARACTER_CLASS_IMAGES_DIR)
boss_image_files = Dir.children(BOSS_IMAGES_DIR)

# Villages
village_comercial = Village.create!(
  name: 'Comercial',
  description: 'Departamento Comercial',
  village_type: :silver_tongues
)

village_marketing = Village.create!(
  name: 'Marketing',
  description: 'Departamento de Marketing',
  village_type: :runemasters
)

village_rh = Village.create!(
  name: 'Gente e Gestão',
  description: 'Recursos Humanos e Departamento Pessoal',
  village_type: :lorekeepers
)

village_qualidade = Village.create!(
  name: 'Sistema Gestão Power',
  description: 'Departamentos de Qualidade, Faculdade e Relacionamento.',
  village_type: :precision_crafters
)

village_ti = Village.create!(
  name: 'TI',
  description: 'Tecnologia da Informação',
  village_type: :arcane_scholars
)

# Slogans para character class
CHARACTER_CLASS_SLOGANS = {
  # Comercial
  'Prospecção Ativa' => 'Onde oportunidades são caçadas, não esperadas!',
  'Fechamento' => 'Transformando interesse em resultado concreto!',
  'Negociação' => 'Criando vitórias onde todos saem ganhando!',
  'Gestão de Pipeline' => 'O funil nunca para quando bem administrado!',

  # SDR
  'Qualificação de Leads' => 'Separando ouro da areia, lead por lead!',
  'Prospecção Outbound' => 'Criando conexões onde antes só havia silêncio!',
  'Follow-up' => 'A persistência é a mãe da conversão!',
  'Script de Vendas' => 'Palavras que abrem portas e fecham negócios!',
  'Cold Calling' => 'Do desconhecido ao interesse genuíno em um telefonema!',
  'Geração de Interesse' => 'Plantando curiosidade, colhendo oportunidades!',

  # Analista de Negócios
  'Mapeamento de Processos' => 'Desvendando os caminhos da eficiência!',
  'Levantamento de Requisitos' => 'Traduzindo necessidades em soluções!',
  'Otimização Operacional' => 'Transformando complexidade em simplicidade!',
  'Inteligência de Mercado' => 'Enxergando o amanhã hoje!',
  'Análise de Dados' => 'Extraindo ouro de montanhas de informação!',
  'Definição de Metas' => 'Traçando rotas para o sucesso mensurável!',
  'Relatórios Gerenciais' => 'Transformando números em narrativas decisórias!',
  'Análise SWOT' => 'Mapeando forças, fraquezas e oportunidades!',
  'Estratégia de Crescimento' => 'Plantando hoje o que será colhido amanhã!',

  # Copywriter
  'Escrita Persuasiva' => 'Palavras que movem mentes e corações!',
  'Storytelling' => 'Contando histórias que vendem sem vender!',
  'Escrita Emocional' => 'Tocando sentimentos através da poderosa arte das palavras!',
  'Escrita para Anúncios' => 'Criando clicks que se transformam em clientes!',

  # Design
  'Branding' => 'Forjando identidades que permanecem na memória!',
  'UX/UI' => 'Onde beleza e funcionalidade se encontram!',
  'Identidade Visual' => 'Dando rosto e alma às marcas!',
  'Web Design' => 'Construindo pontes digitais entre empresas e pessoas!',
  'Materiais Institucionais' => 'Comunicando profissionalismo em cada detalhe!',
  'Edição de Imagens' => 'Transformando o comum em extraordinário!',

  # Videomaker
  'Edição de Vídeo' => 'Costurando emoções frame a frame!',
  'Roteirização' => 'Planejando jornadas visuais cativantes!',
  'Captação de Imagem' => 'Congelando momentos que contam histórias!',
  'Motion Graphics' => 'Dando vida e movimento às ideias!',
  'Pós-Produção' => 'O toque final que transforma bom em excelente!',

  # Traffic Manager
  'Tráfego Pago' => 'Investindo inteligentemente, colhendo resultados!',
  'Tráfego Orgânico' => 'Crescendo com autenticidade e valor real!',
  'Google Ads' => 'Dominando o maior palco digital do mundo!',
  'Segmentação' => 'Acertando em cheio no público certo!',
  'Analytics' => 'Decifrando os segredos escondidos nos dados!',
  'Mídia Programática' => 'Automatizando a eficiência em escala!',
  'Remarketing' => 'Reacendendo chamas que nunca deveriam ter se apagado!',

  # Analista de RH
  'Recrutamento e Seleção' => 'Encontrando talentos que transformam organizações!',
  'Clima Organizacional' => 'Cultivando ambientes onde pessoas florescem!',
  'Treinamento e Desenvolvimento' => 'Forjando habilidades que constroem carreiras!',
  'Cultura Organizacional' => 'Preservando a alma que une times!',
  'Onboarding' => 'Transformando novatos em veteranos em tempo recorde!',
  'Endomarketing' => 'Comunicando para dentro tão bem quanto para fora!',

  # Analista de DP
  'Folha de Pagamento' => 'Garantindo que todo esforço seja justamente recompensado!',
  'Benefícios' => 'Transformando obrigações em vantagens competitivas!',
  'Cálculo de Férias' => 'Calculando o merecido descanso com precisão!',
  'Encargos Sociais' => 'Cumprindo com excelência o que a lei exige!',
  'Admissão e Demissão' => 'Gerindo ciclos com profissionalismo e humanidade!',
  'Controle de Ponto' => 'Registrando cada minuto com exatidão milimétrica!',
  'E-social' => 'Modernizando a gestão com tecnologia e precisão!',

  # Analista de Relacionamento
  'Encantamento' => 'Transformando clientes em fãs fervorosos!',
  'Atendimento Humanizado' => 'Ouvindo não apenas palavras, mas sentimentos!',
  'Resolução de Conflitos' => 'Transformando problemas em oportunidades de conexão!',
  'Feedback do Cliente' => 'Ouvindo para melhorar, sempre!',
  'Pós-Venda' => 'O cuidado que começa onde a venda termina!',
  'Suporte Personalizado' => 'Soluções sob medida para necessidades únicas!',

  # Secretário Acadêmico
  'Gestão de Matrículas' => 'Abridor de portas para o conhecimento!',
  'Organização de Turmas' => 'Criando sinergias de aprendizado!',
  'Emissão de Documentos' => 'Certificando conquistas com precisão!',
  'Atendimento ao Aluno' => 'Guiando mentes em busca do saber!',
  'Processos Acadêmicos' => 'Garantindo fluidez na jornada do conhecimento!',
  'Calendário Acadêmico' => 'Organizando o tempo do aprendizado!',
  'Suporte Administrativo' => 'A base que sustenta o edifício do saber!',

  # Analista de SAC
  'Retenção de Clientes' => 'Transformando clientes em parceiros de longo prazo!',
  'Atendimento Multicanal' => 'Presente em todos os lugares, a qualquer hora!',
  'Resolução de Problemas' => 'Transformando obstáculos em degraus de satisfação!',
  'Satisfação do Cliente' => 'Medindo e maximizando a felicidade do cliente!',
  'Reclamações' => 'Ouvindo críticas para construir elogios futuros!',
  'Comunicação Empática' => 'Conectando-se genuinamente com cada história!',

  # Analista de Qualidade
  'Indicadores de Qualidade' => 'Medindo a excelência em números!',
  'Padronização de Processos' => 'Garantindo consistência na busca pela perfeição!',
  'Avaliação de Performance' => 'Transformando desempenho em progresso mensurável!',
  'Auditoria Interna' => 'Fiscalizando a excelência com olhar crítico!',
  'Acompanhamento de KPIs' => 'Monitorando os sinais vitais do sucesso!',

  # Analista do CAC
  'Suporte ao Coach Formado' => 'Apoiando mestres na arte de transformar vidas!',
  'Gestão de Ferramentas' => 'Fornecendo as armas para batalhas profissionais!',
  'Acompanhamento Acadêmico' => 'Guardião da jornada após a formatura!',
  'Atualização de Conteúdos' => 'Mantendo o conhecimento sempre afiado!',

  # Desenvolvedor
  'Front-End' => 'Dando forma e vida às interfaces!',
  'Back-End' => 'O poder invisível que move tudo!',
  'Full-Stack' => 'Mestre de ambos os mundos digital e físico!',
  'QA' => 'Garantindo que cada linha de código seja impecável!',
  'DevOps' => 'Unindo criação e operação em perfeita harmonia!',

  # Analista de Infraestrutura
  'Telefonia' => 'Mantendo as vozes conectadas!',
  'Hardware' => 'O alquimista das máquinas!',
  'Governança' => 'Estabelecendo ordem no universo digital!'
}

# Nomes para bosses
BOSS_NAMES = [
  'Dmitri Volkov', 'Svetlana Orlova', 'Ivan Petrov', 'Anastasia Volkova',
  'Magnus Thorsen', 'Freya Eriksdotter', 'Bjorn Larsen', 'Sigrid Olafsdottir',
  'Vladislav Novak', 'Katarina Horvat', 'Mikhail Sokolov', 'Nadia Kovac',
  'Lars Magnusson', 'Ingrid Bergman', 'Ragnar Skarsgard', 'Helga Svensson',
  'Sergei Popov', 'Tatiana Ivanova', 'Nikolai Chernov', 'Olga Romanova',
  'Leif Eriksen', 'Astrid Johansen', 'Gunnar Nilsson', 'Solveig Andersson',
  'Boris Dragovich', 'Yelena Smirnova', 'Alexei Volkov', 'Irina Petrovna'
].freeze

# Slogans para bosses
BOSS_SLOGANS = [
  'O Terror dos Prazos Curtos', 'Pesadelo das Planilhas Complexas',
  'Flagelo das Reuniões Intermináveis', 'Devastador dos Orçamentos',
  'Assombração dos Projetos Atrasados', 'Sombra dos Processos Burocráticos',
  'Tirano dos Relatórios Inúteis', 'Carrasco das Metas Impossíveis',
  'Espectro do Wi-Fi Instável', 'Lorde das Atualizações de Última Hora',
  'Ditador das Mudanças de Escopo', 'Inquisidor dos Feedbacks',
  'Aniquilador dos Projetos Abandonados', 'Feiticeiro dos Sistemas que Caem',
  'Guerreiro das Ocorrências Críticas', 'Conquistador dos Horários Extendidos',
  'Dominador das Expectativas Irreais', 'Guardião da Documentação Incompleta',
  'Manipulador dos Requisitos Ambíguos', 'Suserano das Revisões Infinitas',
  'Titan da Microgestão', 'Colosso da Comunicação Falha',
  'Destruidor dos Retrabalhos', 'Renascido dos Problemas Recorrentes',
  'Estrangulador da Complexidade Desnecessária', 'Labirinteiro das Aprovações',
  'Vigia do Foco Perdido', 'Cerberiano dos Bloqueios Múltiplos',
  'Opressor das Entregas Urgentes', 'Tormento dos Relatórios Gerenciais'
].freeze

CHAPTERS_DESCRIPTION = [
  # Capítulo 1-5 (Pré-boss 6)
  "A guilda se reúne para um novo desafio. A névoa da floresta parece mais densa, e a estrada adiante é cheia de perigos. Cada passo é uma preparação para o que virá.",
  "O vento cortante sopra pelas planícies, e a guilda encontra um vilarejo abandonado. Os ecos do passado sussurram, mas nenhum inimigo aparece... por enquanto.",
  "Em uma caverna profunda, a guilda encontra antigas inscrições. Algo grande está por vir, mas a escuridão impede que revelem o que está à frente.",
  "A guilda atravessa um rio turbulento, onde criaturas aquáticas espreitam nas sombras. A tensão é palpável, mas nenhum ataque ocorre. O medo se espalha.",
  "As ruínas de um antigo castelo surgem à vista. Lendas falam de um grande tesouro, mas o silêncio daquelas paredes conta uma história de terror.",

  # Capítulo 6 (BOSS)
  "A guilda chega ao território do primeiro grande desafio. Uma sombra emerge da névoa: um chefe de guerra que lidera criaturas selvagens. A batalha será imensa.",

  # Capítulo 7-14 (Entre bosses 6 e 15)
  "Após a vitória contra o primeiro grande inimigo, a guilda se fortalece. As cicatrizes da batalha ainda ardem, mas o espírito está firme. O próximo desafio se aproxima.",
  "Em uma planície desolada, vestígios de antigos exércitos podem ser vistos. Mas ainda não se ouve a batalha. O silêncio prepara a guilda para o próximo teste.",
  "A guilda atravessa um bosque de árvores antigas, cujos galhos parecem vigiar cada movimento. Um calafrio percorre a espinha, e os inimigos começam a se mover nas sombras.",
  "O céu se enegrece. Grandes nuvens se formam, e uma tempestade se aproxima. O clamor das criaturas do céu se faz ouvir. A guilda precisa se unir mais do que nunca.",
  "A guilda chega aos confins do deserto. O calor é insuportável, mas a missão é clara: encontrar o oásis de El-Karim antes que o sol se ponha e as criaturas noturnas despertem.",
  "A entrada do labirinto se revela, e os passos da guilda ecoam pelas paredes frias. O desafio da mente aguarda, e somente os mais sábios conseguirão conduzir todos à saída.",
  "A guilda encontra um vale repleto de criaturas imortais, que buscam desafiar os mais corajosos. O cheiro de morte no ar é inconfundível. A sobrevivência depende de rapidez e força.",
  "Ao atravessar as montanhas geladas, a guilda é cercada por lobos sobrenaturais, famintos por carne e alma. A força da guilda será testada mais uma vez, mas a união os levará à vitória.",

  # Capítulo 15 (BOSS)
  "Em um campo de batalha antigo, a guilda encontra as armas perdidas de grandes heróis. Mas algo está errado... a terra treme, e os mortos começam a se levantar.",

  # Capítulo 16-20 (Entre bosses 15 e 21)
  "A guilda chega à Fortaleza Sombria, onde um antigo mal repousa. As portas estão fechadas, e os ventos uivam de uma maneira que nunca tinham ouvido antes. Algo grande está por vir.",
  "A guilda se prepara para o combate mais difícil. A sombra do boss se aproxima, e as lendas falam de sua crueldade. Apenas os mais fortes sobreviverão a essa luta.",
  "Com a vitória sobre o primeiro chefe, a guilda sente uma sensação de poder crescente. Mas, no horizonte, outras ameaças surgem. O próximo desafio parece maior, mais sombrio.",
  "A guilda enfrenta uma legião de criaturas controladas por uma força obscura. A luta é feroz, mas a união e o espírito de combate da guilda nunca foram tão fortes.",
  "Nas profundezas de uma masmorra esquecida, a guilda encontra artefatos poderosos. Mas uma presença maligna os observa, pronta para atacar a qualquer momento.",

  # Capítulo 21 (BOSS)
  "O clima torna-se instável à medida que a guilda atravessa um pântano. As névoas enganam os sentidos, e as criaturas das profundezas começam a emergir com uma fúria selvagem.",

  # Capítulo 22-27 (Entre bosses 21 e 28)
  "A guilda chega a um antigo templo perdido. A escuridão se estende por todo o local, e uma presença maléfica se faz sentir. Os perigos são muitos, mas a guilda deve seguir em frente.",
  "Em uma selva densa, a guilda encontra uma tribo perdida. Mas as lendas sobre eles são mais sombrias do que esperavam. A cada passo, a desconfiança cresce.",
  "O céu se clareia, mas a guilda sente uma tempestade interna. O chefe que se aproxima não será apenas um teste de força, mas de coragem. O destino da guilda está em jogo.",
  "A guilda finalmente chega ao local do próximo boss. O terreno é árido e desolado, mas uma sombra se ergue no horizonte. A batalha será sangrenta.",
  "Depois da vitória, o espírito da guilda está inquebrantável. Mas algo sinistro ronda nas bordas da cidade. A próxima fase não será menos mortal.",
  "A guilda viaja por uma ponte antiga que atravessa um abismo profundo. A cada passo, o medo aumenta, mas também a esperança de que o grande objetivo está perto.",

  # Capítulo 28 (BOSS)
  "Em uma floresta mágica, os membros da guilda começam a ter visões de um futuro incerto. Mas elas revelam um caminho. Agora, cabe à guilda seguir o que o destino mostrou.",

  # Capítulo 29-35 (Entre bosses 28 e 36)
  "O vento uiva nas montanhas onde o próximo boss se esconde. Sua força é imensurável, mas a guilda está mais forte e unida do que nunca. A batalha será feroz.",
  "Com a vitória sobre outro boss, a guilda sente que está chegando mais perto de seu objetivo final. Mas o que aguarda nas próximas fases é algo que ninguém poderia prever.",
  "A guilda chega a uma cidade em ruínas, tomada por uma peste mortal. Mas as lendas dizem que um artefato perdido se encontra em seu centro. Eles precisam correr contra o tempo.",
  "A travessia do rio negro marca o limite entre o mundo dos vivos e o dos mortos. A guilda deve enfrentar os espectros que surgem das águas antes que a realidade se quebre.",
  "A guilda encontra um antigo rival que há muito foi dado como morto. Mas a guerra com ele não terminou. O confronto será sangrento e cheio de reviravoltas.",
  "A tempestade cresce ao redor da guilda enquanto eles avançam para a caverna do próximo chefe. A escuridão parece tomar forma, e uma grande ameaça aguarda.",
  "Em uma grande arena, os guerreiros da guilda enfrentam um novo desafio: guerreiros que não são humanos, mas criaturas forjadas por magia negra. A vitória será difícil, mas não impossível.",

  # Capítulo 36 (BOSS)
  "O silêncio toma conta da guilda à medida que eles se aproximam do próximo boss. A força maligna é palpável, mas a determinação é ainda maior.",

  # Capítulo 37-42 (Entre bosses 36 e 43)
  "As terras próximas à fortaleza do próximo chefe são amaldiçoadas. A guilda deve encontrar uma maneira de quebrar a maldição antes de enfrentar a terrível criatura.",
  "O grande confronto com o chefe está prestes a começar. A guilda se prepara para a batalha final. Os corações batem fortes, e o futuro da terra está em suas mãos.",
  "Após uma vitória difícil, a guilda se reagrupa. Mas algo ainda paira no ar: uma sombra que ameaça o mundo. A verdadeira batalha está apenas começando.",
  "A guilda segue adiante e encontra cavernas de cristal que irradiam energia mágica. Cada passo fortalece os laços do grupo, mas também atrai forças que não deveriam ser despertadas.",
  "No fundo das cavernas, um portal antigo começa a se abrir. A guilda percebe que está prestes a cruzar para um território onde nenhuma luz alcança.",
  "Atravessando o portal, a guilda chega ao Reino da Sombra. O ar é pesado, e a própria terra parece gritar de dolor. O próximo inimigo será mais cruel do que qualquer um antes.",

  # Capítulo 43 (BOSS)
  "Um arauto do caos surge, anunciando o despertar de um dos maiores bosses. A guilda sente o peso da história sobre seus ombros: a batalha decidirá o destino do reino.",

  # Capítulo 44-47 (Entre bosses 43 e 48)
  "O confronto com o boss começa. Ele domina o campo com poderes que distorcem a realidade. Cada ataque é um teste para o espírito e a coragem da guilda.",
  "A vitória chega, mas com um preço alto. Muitos estão feridos, e a esperança quase se perde. Ainda assim, a guilda sabe que deve continuar.",
  "Nas montanhas de cinzas, a guilda enfrenta guerreiros caídos que nunca encontraram descanso. Eles lutam com ódio eterno, dificultando cada avanço.",
  "O vento traz o cheiro de enxofre. A guilda sabe que está próxima do covil de outro boss. O mundo parece tremer diante da presença que os aguarda.",

  # Capítulo 48 (BOSS)
  "O boss irrompe das profundezas: um titã de fogo e destruição. Cada golpe dele abala a terra, e a guilda precisa de toda sua união para resistir.",

  # Capítulo 49-51 (Entre bosses 48 e 52/53)
  "Ainda com o fogo da batalha em suas memórias, a guilda segue pelas terras carbonizadas. A vitória os fortalece, mas o desgaste é imenso.",
  "Em meio às cinzas, uma estranha calma reina. É o prenúncio de uma sequência de lutas ainda maiores. O ar está pesado demais para ser ignorado.",
  "A guilda chega diante de dois portões colossais. Cada um leva a uma batalha diferente, mas ambos guardam bosses poderosos. O destino não permitirá descanso.",

  # Capítulo 52 (BOSS)
  "O primeiro dos dois bosses surge, com armadura de ossos e olhos em chamas. A luta é brutal, mas a guilda prevalece.",

  # Capítulo 53 (BOSS)
  "Sem tempo para respirar, o segundo boss se revela. Um ser alado, alimentado por trevas, ataca com fúria incontrolável. A guilda deve lutar como nunca antes.",

  # Capítulo 54-55 (Entre bosses 53 e 56)
  "Após vitórias consecutivas, a guilda mal consegue se erguer. Mas a esperança de salvar o mundo os mantém firmes no caminho.",
  "Atravessando terras envenenadas, a guilda enfrenta criaturas deformadas pelo caos. Cada passo é uma luta contra a corrupção que ameaça a todos.",

  # Capítulo 56 (BOSS)
  "Um antigo guardião aparece para testar a guilda. Não é maligno, mas só permitirá que passem se provarem sua dignidade.",

  # Capítulo 57-63 (Entre bosses 56 e 64)
  "A guilda chega ao Lago da Eternidade. A superfície reflete pesadelos, e monstros surgem das profundezas. A luta é contra a mente e contra a carne.",
  "O próximo boss aguarda no centro do lago. Um leviatã colossal desperta, cobrindo o céu com sua sombra. A batalha é desesperadora.",
  "A vitória sobre o leviatã enche a guilda de confiança, mas o mundo continua se quebrando. O tempo para deter o caos está se esgotando.",
  "A guilda entra em uma floresta cristalina. A beleza do lugar esconde perigos letais, e armadilhas naturais os desafiam a cada passo.",
  "Entre as árvores cristalinas, um eco maligno ressoa. A guilda sabe que está próxima de mais um chefe.",
  "O boss surge, moldado pelos próprios cristais. Seus ataques refletem e multiplicam a dor. A guilda precisa lutar com inteligência e coragem.",
  "Com a vitória, o brilho da floresta desaparece. A guilda segue, mas o silêncio que resta é perturbador.",

  # Capítulo 64 (BOSS)
  "Nas ruínas de uma antiga cidade, espectros clamam por vingança. O número de inimigos é esmagador, e a guilda precisa resistir à exaustão.",

  # Capítulo 65-73 (Entre bosses 64 e 74)
  "Uma torre imensa se ergue ao longe. Lá dentro, mais um boss os aguarda, irradiando um poder capaz de destruir continentes.",
  "No topo da torre, a guilda enfrenta o boss. Ele manipula o tempo, tornando cada movimento mais difícil. A luta é quase impossível.",
  "Com esforço sobre-humano, a guilda vence. Mas o relógio do mundo está quebrado, e as fissuras da realidade se ampliam.",
  "A guilda cruza um campo devastado por batalhas ancestrais. Ossos e espadas cravados no chão contam histórias de guerras esquecidas.",
  "Um arauto do apocalipse aparece, convocando a guilda para a penúltima grande luta. A escuridão cobre tudo ao redor.",
  "O boss surge: um colosso que carrega as memórias de todas as batalhas perdidas. A guilda precisa lutar contra o peso da própria história.",
  "A vitória é amarga. O mundo começa a ruir, e a guilda sente que resta apenas um último desafio.",
  "A terra treme, o céu se parte, e o boss final desperta. Ele é o caos encarnado, a destruição em sua forma pura.",
  "A última batalha é travada no limiar entre mundos. A guilda precisa lutar com tudo que possui — falhar não é uma opção.",

  # Capítulo 74 (BOSS)
  "Com a derrota do boss final, a luz retorna. Mas o equilíbrio é frágil, e a guilda sabe que sua lenda apenas começou.",

  # Capítulo 75-77 (Entre bosses 74 e 78/79)
  "A guilda é celebrada como salvadora, mas o horizonte ainda guarda sombras. O ciclo da guerra nunca acaba totalmente.",
  "Agora, como lendas vivas, os heróis compreendem que cada vitória abre caminho para novos perigos. O destino do mundo está para sempre em suas mãos.",
  "O descanso é breve, pois novos ecos de guerra surgem no horizonte. A guilda se prepara para mais uma jornada épica.",

  # Capítulo 78 (BOSS)
  "Uma ameaça ancestral desperta das profundezas, desafiando a guilda a uma batalha que testará seus limites finais.",

  # Capítulo 79 (BOSS FINAL)
  "O confronto definitivo contra a escuridão primordial. Tudo o que foi aprendido e conquistado levará a este momento final."
].freeze


# Narrators, Guilds, Specializations e CharacterClass
narrators = [
  {
    name: 'Gestão Comercial',
    nickname: 'narrator-comercial',
    email: 'comercial.ibc@techraids.com.br',
    village: village_comercial,
    guild: {
      name: 'Comercial',
      description: 'Equipe Comercial',
      specializations: [
        {
          title: 'Consultor Comercial',
          description: 'Responsável por prospecção e fechamento de negócios',
          character_classes: [
            'Prospecção Ativa',
            'Fechamento',
            'Negociação',
            'Gestão de Pipeline'
          ]
        }
      ]
    }
  },
  {
    name: 'Gestão SDR',
    nickname: 'narrator-pvd',
    email: 'pvd.ibc@techraids.com.br',
    village: village_comercial,
    guild: {
      name: 'SDR',
      description: 'Equipe de Pré-Vendas',
      specializations: [
        {
          title: 'SDR',
          description: 'Responsável por qualificação de leads e prospecção',
          character_classes: [
            'Qualificação de Leads',
            'Prospecção Outbound',
            'Follow-up',
            'Script de Vendas',
            'Cold Calling',
            'Geração de Interesse'
          ]
        }
      ]
    }
  },
  {
    name: 'Gestão Suporte de Negócios',
    nickname: 'narrator-negocios',
    email: 'suporte.ibc@techraids.com.br',
    village: village_comercial,
    guild: {
      name: 'Suporte de Negócios',
      description: 'Equipe de Suporte a Negócios',
      specializations: [
        {
          title: 'Analista de Negócios',
          description: 'Responsável por análise e otimização de processos',
          character_classes: [
            'Mapeamento de Processos',
            'Levantamento de Requisitos',
            'Otimização Operacional',
            'Inteligência de Mercado',
            'Análise de Dados',
            'Definição de Metas',
            'Relatórios Gerenciais',
            'Análise SWOT',
            'Estratégia de Crescimento'
          ]
        }
      ]
    }
  },
  {
    name: 'Gestão Marketing',
    nickname: 'narrator-mkt',
    email: 'marketing.ibc@techraids.com.br',
    village: village_marketing,
    guild: {
      name: 'Marketing',
      description: 'Equipe de Marketing',
      specializations: [
        {
          title: 'Copywriter',
          description: 'Responsável por criação de conteúdo persuasivo',
          character_classes: [
            'Escrita Persuasiva',
            'Storytelling',
            'Escrita Emocional',
            'Escrita para Anúncios'
          ]
        },
        {
          title: 'Design',
          description: 'Responsável por criação visual',
          character_classes: [
            'Branding',
            'UX/UI',
            'Identidade Visual',
            'Web Design',
            'Materiais Institucionais',
            'Edição de Imagens'
          ]
        },
        {
          title: 'Videomaker',
          description: 'Responsável por produção de vídeos',
          character_classes: [
            'Edição de Vídeo',
            'Roteirização',
            'Captação de Imagem',
            'Motion Graphics',
            'Pós-Produção'
          ]
        },
        {
          title: 'Traffic Manager',
          description: 'Responsável por gestão de tráfego',
          character_classes: [
            'Tráfego Pago',
            'Tráfego Orgânico',
            'Google Ads',
            'Segmentação',
            'Analytics',
            'Mídia Programática',
            'Remarketing'
          ]
        }
      ]
    }
  },
  {
    name: 'Gestão RH/DP',
    nickname: 'narrator-rh',
    email: 'genteegestao.ibc@techraids.com.br',
    village: village_rh,
    guild: {
      name: 'Gente e Gestão',
      description: 'Equipe de RH e DP',
      specializations: [
        {
          title: 'Analista de RH',
          description: 'Responsável por gestão de pessoas',
          character_classes: [
            'Recrutamento e Seleção',
            'Clima Organizacional',
            'Treinamento e Desenvolvimento',
            'Cultura Organizacional',
            'Onboarding',
            'Endomarketing'
          ]
        },
        {
          title: 'Analista de DP',
          description: 'Responsável por departamento pessoal',
          character_classes: [
            'Folha de Pagamento',
            'Benefícios',
            'Cálculo de Férias',
            'Encargos Sociais',
            'Admissão e Demissão',
            'Controle de Ponto',
            'E-social'
          ]
        }
      ]
    }
  },
  {
    name: 'Gestão SGP',
    nickname: 'narrator-qualidade',
    email: 'sgp.ibc@techraids.com.br',
    village: village_qualidade,
    guild: {
      name: 'Sistema Gestão Power',
      description: 'Equipe de Qualidade, Faculdade e Relacionamento',
      specializations: [
        {
          title: 'Analista de Relacionamento',
          description: 'Responsável por encantamento de clientes',
          character_classes: [
            'Encantamento',
            'Atendimento Humanizado',
            'Resolução de Conflitos',
            'Feedback do Cliente',
            'Pós-Venda',
            'Suporte Personalizado'
          ]
        },
        {
          title: 'Secretário Acadêmico',
          description: 'Responsável por processos acadêmicos',
          character_classes: [
            'Gestão de Matrículas',
            'Organização de Turmas',
            'Emissão de Documentos',
            'Atendimento ao Aluno',
            'Processos Acadêmicos',
            'Calendário Acadêmico',
            'Suporte Administrativo'
          ]
        },
        {
          title: 'Analista de SAC',
          description: 'Responsável por atendimento ao cliente',
          character_classes: [
            'Retenção de Clientes',
            'Atendimento Multicanal',
            'Resolução de Problemas',
            'Satisfação do Cliente',
            'Reclamações',
            'Comunicação Empática'
          ]
        },
        {
          title: 'Analista de Qualidade',
          description: 'Responsável por indicadores de qualidade',
          character_classes: [
            'Indicadores de Qualidade',
            'Padronização de Processos',
            'Avaliação de Performance',
            'Auditoria Interna',
            'Acompanhamento de KPIs'
          ]
        },
        {
        title: 'Analista do CAC',
        description: 'Responsável por apoio acadêmico e administrativo para alunos de Coaching',
        character_classes: [
          'Suporte ao Coach Formado',
          'Gestão de Ferramentas',
          'Acompanhamento Acadêmico',
          'Atualização de Conteúdos'
        ]
      }
      ]
    }
  },
  {
    name: 'Gestão TI',
    nickname: 'narrator-ti',
    email: 'ti.ibc@techraids.com.br',
    village: village_ti,
    guild: {
      name: 'Tecnologia da Informação',
      description: 'Equipe de TI',
      specializations: [
        {
          title: 'Desenvolvedor',
          description: 'Responsável por desenvolvimento de software',
          character_classes: [
            'Front-End',
            'Back-End',
            'Full-Stack',
            'QA',
            'DevOps'
          ]
        },
        {
          title: 'Analista de Infraestrutura',
          description: 'Responsável por infraestrutura de TI',
          character_classes: [
            'Telefonia',
            'Hardware',
            'Governança'
          ]
        }
      ]
    }
  }
]

narrators.each do |narrator_data|
  narrator = User.create!(
    name: narrator_data[:name],
    nickname: narrator_data[:nickname],
    email: narrator_data[:email],
    password: 'password',
    role: :narrator,
    village: narrator_data[:village],
    confirmed_at: Time.now
  )

  guild_data = narrator_data[:guild]
  guild = Guild.create!(
    name: guild_data[:name],
    description: guild_data[:description],
    village: narrator_data[:village],
    narrator: narrator
  )

  guild_data[:specializations].each do |spec_data|
    specialization = Specialization.create!(
      title: spec_data[:title],
      description: spec_data[:description],
      guild: guild
    )

    used_male_images = []
    used_female_images = []

    spec_data[:character_classes].each do |class_name|
      available_male_images = male_character_class_image_files - used_male_images
      available_female_images = female_character_class_image_files - used_female_images

      selected_male_images = available_male_images.sample(3)
      selected_female_images = available_female_images.sample(3)

      used_male_images.concat(selected_male_images)
      used_female_images.concat(selected_female_images)

      selected_male_images.each do |male_image|
        male_character_class = CharacterClass.create!(
          name: class_name,
          slogan: CHARACTER_CLASS_SLOGANS[class_name],
          required_experience: 0,
          entry_fee: 0,
          specialization: specialization,
        )
        attach_random_image(male_character_class, MALE_CHARACTER_CLASS_IMAGES_DIR, [ male_image ])
      end

      selected_female_images.each do |female_image|
        female_character_class = CharacterClass.create!(
          name: class_name,
          slogan: CHARACTER_CLASS_SLOGANS[class_name],
          required_experience: 0,
          entry_fee: 0,
          specialization: specialization,
        )
        attach_random_image(female_character_class, FEMALE_CHARACTER_CLASS_IMAGES_DIR, [ female_image ])
      end
    end
  end

  quest = Quest.create!(
    title: "Jornada - #{guild.name}",
    description: "Domine a área e melhore suas habilidades!",
    guild: guild
  )

  boss_chapter_indices = [ 6, 15, 21, 28, 36, 43, 48, 52, 53, 56, 64, 74, 78, 79 ]

  required_experience = 0

  points.each_with_index do |point, i|
    chapter_number = i + 1
    is_boss_chapter = boss_chapter_indices.include?(chapter_number)
    required_experience = is_boss_chapter ? required_experience + 200 : required_experience + 150

    chapter = Chapter.create!(
      title: "Capítulo #{chapter_number}",
      description: CHAPTERS_DESCRIPTION[i],
      required_experience: required_experience,
      quest: quest,
      position_x: point["x"],
      position_y: point["y"],
      position: chapter_number
    )

    if is_boss_chapter
      boss = Boss.create!(
        name: BOSS_NAMES.sample,
        slogan: BOSS_SLOGANS.sample,
        description: "Um temido chefe no capítulo #{chapter.title}",
        chapter: chapter,
        defeated: false,
        reward_claimed: false,
        reward_description: ""
      )
      attach_random_image(boss, BOSS_IMAGES_DIR, boss_image_files)
    end
  end
end

puts 'Seed de população inicial criado com sucesso!'
