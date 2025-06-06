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
CHARACTER_CLASS_IMAGES_DIR = Rails.root.join('db', 'seeds', 'images', 'character_class')
BOSS_IMAGES_DIR = Rails.root.join('db', 'seeds', 'images', 'boss')
user_image_files = Dir.children(USER_IMAGES_DIR)
character_class_image_files = Dir.children(CHARACTER_CLASS_IMAGES_DIR)
boss_image_files = Dir.children(BOSS_IMAGES_DIR)

# Villages
village_ti = Village.create!(name: 'TI', description: 'Departamento de Tecnologia da Informação', village_type: :arcane_scholars)
village_rh = Village.create!(name: 'RH/DP', description: 'Recursos Humanos e Departamento Pessoal', village_type: :lorekeepers)
village_mkt = Village.create!(name: 'Marketing', description: 'Departamento de Marketing', village_type: :runemasters)

# Narrators
narrators = [
  {
    name: 'Gestor de Dev', nickname: 'narrator-dev', email: 'dev@techraids.com', village: village_ti,
    guild: { name: 'Dev', description: 'Equipe de Desenvolvimento', specializations: [ 'Front-end', 'Back-end', 'Full-stack', 'QA', 'DevOps' ] }
  },
  {
    name: 'Gestor de Infra', nickname: 'narrator-infra', email: 'infra@techraids.com', village: village_ti,
    guild: { name: 'Infra', description: 'Equipe de Infraestrutura', specializations: [ 'Redes', 'Telefonia', 'Hardware' ] }
  },
  {
    name: 'Gestor de RH', nickname: 'narrator-rh', email: 'rh@techraids.com', village: village_rh,
    guild: { name: 'RH', description: 'Equipe de Recrutamento e Seleção', specializations: [ 'Seleção', 'Onboarding', 'Treinamento' ] }
  },
  {
    name: 'Gestor de Marketing', nickname: 'narrator-mkt', email: 'marketing@techraids.com', village: village_mkt,
    guild: { name: 'Digital', description: 'Marketing Digital', specializations: [ 'Mídias Sociais', 'SEO', 'Conteúdo' ] }
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

  guild_data[:specializations].each do |spec|
    specialization = Specialization.create!(
      title: spec,
      description: "Especialização em #{spec}",
      guild: guild
    )

    [
      { times: 3, experience: 0, fee: 0 },
      { times: 2, experience: -> { rand(100..1000) }, fee: -> { rand(10..50) } }
    ].each do |config|
      config[:times].times do
        character_class = CharacterClass.create!(
          name: Faker::Job.title,
          slogan: Faker::Lorem.sentence,
          required_experience: config[:experience].respond_to?(:call) ? config[:experience].call : config[:experience],
          entry_fee: config[:fee].respond_to?(:call) ? config[:fee].call : config[:fee],
          specialization: specialization
        )

        attach_random_image(character_class, CHARACTER_CLASS_IMAGES_DIR, character_class_image_files)
      end
    end
  end

  quest = Quest.create!(
    title: "Jornada do #{guild.name}",
    description: "Domine as habilidades de #{guild.name}",
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

Guild.all.each do |guild|
  10.times do
    experience = rand(0..10000)
    spec = guild.specializations.sample
    quest = guild.quest
    chapter_index = [ (experience / 150).to_i - 1, 0 ].max
    chapter_index = [ chapter_index, quest.chapters.count - 1 ].min
    current_chapter = quest.chapters.offset(chapter_index).first || quest.chapters.first

    nickname = loop do
      name = Faker::Internet.unique.username
      break name unless User.exists?(nickname: name)
    end

    email = loop do
      addr = Faker::Internet.unique.email
      break addr unless User.exists?(email: addr)
    end

    character = User.create!(
      name: Faker::Name.name,
      nickname: nickname,
      email: email,
      password: 'password',
      role: :character,
      village: guild.village,
      guild: guild,
      current_chapter: current_chapter,
      character_class: spec.character_classes.sample,
      specialization: spec,
      experience: experience,
      gold: rand(0..500),
      confirmed_at: Time.now
    )

    attach_random_image(character, USER_IMAGES_DIR, user_image_files, :photo)
  end
end

# HonoraryTitles
titles = [ 'Mestre do React', 'Guru do Docker', 'Rei do Rails', 'Lorde do VD', 'Defensor dos Periféricos',
  'Recrutador Supremo', 'Mestre dos Benefícios', 'Encantador de Candidatos',
  'Rei das Redes Sociais', 'Mago do SEO', 'Lorde do Conteúdo' ]

titles.each do |title|
  character = User.where(role: :character).sample
  next unless character && character.guild&.narrator
  HonoraryTitle.create!(
    title: title,
    slogan: Faker::Lorem.sentence,
    character: character,
    narrator: character.guild.narrator
  )
end

# TreasureChests
Guild.all.each do |guild|
  2.times do
    chest = TreasureChest.create!(
      title: Faker::Games::Zelda.item,
      value: rand(100..500),
      active: true,
      guild: guild
    )

    3.times do
      Reward.create!(
        name: Faker::Commerce.product_name,
        description: Faker::Lorem.paragraph,
        reward_type: rand(0..3),
        is_limited: [ true, false ].sample,
        stock_quantity: rand(5..25),
        treasure_chest: chest
      )
    end
  end
end

# CharacterTreasureChests
User.where(role: :character).each do |character|
  chest = TreasureChest.where(guild: character.guild).sample
  next unless chest && chest.rewards.any?

  CharacterTreasureChest.create!(
    character: character,
    treasure_chest: chest,
    reward: chest.rewards.sample
  )
end

# ArcaneAnnouncements
if (rh_narrator = User.find_by(email: 'rh@techraids.com'))
  [
    { title: 'Mudanças no processo de férias', priority: :high },
    { title: 'Novos benefícios disponíveis', priority: :normal },
    { title: 'URGENTE: Atualização de documentos', priority: :critical }
  ].each do |a|
    ArcaneAnnouncement.create!(
      title: a[:title],
      content: Faker::Lorem.paragraph(sentence_count: 4),
      announcement_type: :lore_whisper,
      priority: a[:priority],
      active: true,
      village: rh_narrator.village,
      author: rh_narrator
    )
  end
end

# GuildNotices
User.where(role: :narrator).each do |narrator|
  guild = narrator.managed_guild
  next unless guild

  [
    { title: 'Atualização de processos', priority: :normal },
    { title: 'Reunião importante', priority: :high },
    { title: 'URGENTE: Problema crítico', priority: :critical },
    { title: 'Informação geral', priority: :low }
  ].each do |n|
    GuildNotice.create!(
      title: n[:title],
      content: Faker::Lorem.paragraph(sentence_count: 3),
      priority: n[:priority],
      active: true,
      guild: guild,
      author: narrator
    )
  end
end

# Missions e Tasks
User.where(role: :character).each do |character|
  5.times do
    status = rand(0..2)
    completed_at = (status == 1 ? Time.now : nil)

    Mission.create!(
      title: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph,
      status: status,
      gold_reward: rand(50..200),
      completed_at: completed_at,
      character: character,
      narrator: character.guild.narrator
    )

    2.times do
      Task.create!(
        title: Faker::Lorem.sentence,
        description: Faker::Lorem.paragraph,
        status: status,
        experience_reward: rand(10..100),
        completed_at: completed_at,
        character: character,
        narrator: character.guild.narrator
      )
    end
  end
end

puts 'Seeds criados com sucesso!'
