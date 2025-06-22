require 'faker'
Faker::Config.default_locale = :pt
Faker::UniqueGenerator.clear

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
USER_IMAGES_DIR = Rails.root.join('db', 'seeds', 'images', 'character')
MALE_CHARACTER_CLASS_IMAGES_DIR = Rails.root.join('db', 'seeds', 'images', 'character_class', 'male')
FEMALE_CHARACTER_CLASS_IMAGES_DIR = Rails.root.join('db', 'seeds', 'images', 'character_class', 'female')
BOSS_IMAGES_DIR = Rails.root.join('db', 'seeds', 'images', 'boss')
user_image_files = Dir.children(USER_IMAGES_DIR)
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
    name: 'Gestão Pre-Vendas',
    nickname: 'narrator-pvd',
    email: 'pvd.ibc@techraids.com.br',
    village: village_comercial,
    guild: {
      name: 'Pre-Vendas',
      description: 'Equipe de Pré-Vendas',
      specializations: [
        {
          title: 'Agente de Pre-Vendas',
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

  attach_random_image(narrator, USER_IMAGES_DIR, user_image_files, :photo)

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

      male_image = available_male_images.sample
      female_image = available_female_images.sample

      used_male_images << male_image
      used_female_images << female_image

      male_character_class = CharacterClass.create!(
        name: class_name,
        slogan: Faker::Lorem.sentence,
        required_experience: 0,
        entry_fee: 0,
        specialization: specialization,
      )
      attach_random_image(male_character_class, MALE_CHARACTER_CLASS_IMAGES_DIR, [ male_image ])

      female_character_class = CharacterClass.create!(
        name: class_name,
        slogan: male_character_class.slogan,
        required_experience: 0,
        entry_fee: 0,
        specialization: specialization,
      )
      attach_random_image(female_character_class, FEMALE_CHARACTER_CLASS_IMAGES_DIR, [ female_image ])
    end
  end

  quest = Quest.create!(
    title: "Jornada - #{guild.name}",
    description: "Domine a área e melhore suas habilidades!",
    guild: guild
  )

  boss_chapter_indices = [ 6, 15, 21, 28, 36, 43, 48, 52, 53, 56, 64, 74, 78, 79 ]

  points.each_with_index do |point, i|
    chapter_number = i + 1
    base_experience = chapter_number * 150
    is_boss_chapter = boss_chapter_indices.include?(chapter_number)

    chapter = Chapter.create!(
      title: "Capítulo #{chapter_number}",
      description: Faker::Lorem.paragraph,
      required_experience: is_boss_chapter ? base_experience + 200 : base_experience,
      quest: quest,
      position_x: point["x"],
      position_y: point["y"],
      position: chapter_number
    )

    if is_boss_chapter
      boss = Boss.create!(
        name: Faker::Games::ElderScrolls.creature,
        slogan: Faker::Quotes::Shakespeare.hamlet_quote,
        description: "Um chefe no capítulo #{chapter.title}",
        chapter: chapter,
        defeated: false,
        reward_claimed: false,
        reward_description: Faker::Lorem.sentence
      )
      attach_random_image(boss, BOSS_IMAGES_DIR, boss_image_files)
    end
  end
end

puts 'Seed de população inicial criado com sucesso!'
