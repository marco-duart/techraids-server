require 'faker'
Faker::Config.default_locale = :pt

# Pontos do Mapa
points_file = Rails.root.join('db', 'seeds', 'json', 'points.json')
points = JSON.parse(File.read(points_file))

# Imagens
USER_IMAGES_DIR = Rails.root.join('db', 'seeds', 'images', 'character')
CHARACTER_CLASS_IMAGES_DIR = Rails.root.join('db', 'seeds', 'images', 'character_class')
user_image_files = Dir.children(USER_IMAGES_DIR)
character_class_image_files = Dir.children(CHARACTER_CLASS_IMAGES_DIR)

# Village
village = Village.create!(name: 'TI', description: 'Departamento de Tecnologia da Informação', village_type: 0)

# Narrator (Gestor)
narrator = User.create!(
  name: Faker::Name.name,
  email: 'narrator@techraids.com',
  password: 'password',
  role: :narrator,
  village: village,
  confirmed_at: Time.now
)
if user_image_files.any?
  image_path = USER_IMAGES_DIR.join(user_image_files.sample)
  narrator.photo.attach(io: File.open(image_path), filename: File.basename(image_path))
end

# Guilds
guild_dev = Guild.create!(name: 'Dev', description: 'Equipe de Desenvolvimento', village: village, narrator: narrator)
guild_infra = Guild.create!(name: 'Infra', description: 'Equipe de Infraestrutura', village: village, narrator: narrator)

# Specializations
specializations_dev = [ 'Front-end', 'Back-end', 'Full-stack', 'QA', 'DevOps' ]
specializations_infra = [ 'Redes', 'Telefonia', 'Hardware' ]

specializations_dev.each do |spec|
  Specialization.create!(
    title: spec,
    description: "Especialização em #{spec}",
    guild: guild_dev
  )
end
specializations_infra.each do |spec|
  Specialization.create!(
    title: spec,
    description: "Especialização em #{spec}",
    guild: guild_infra
  )
end

# CharacterClasses
Specialization.all.each do |spec|
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
        specialization: spec
      )

      if character_class_image_files.any?
        image_path = CHARACTER_CLASS_IMAGES_DIR.join(character_class_image_files.sample)
        character_class.image.attach(io: File.open(image_path), filename: File.basename(image_path))
      end
    end
  end
end

# Quests
quest_dev = Quest.create!(title: 'Jornada do Desenvolvedor', description: 'Domine o desenvolvimento.', guild: guild_dev)
quest_infra = Quest.create!(title: 'Jornada do Infra', description: 'Domine a infraestrutura.', guild: guild_infra)

# Chapters e Bosses
quests = [ quest_dev, quest_infra ]
boss_chapter_indices = [ 6, 15, 21, 28, 36, 43, 48, 52, 53, 56, 64, 74, 78, 79 ]

quests.each do |quest|
  points.each_with_index do |point, i|
    base_experience = (i + 1) * 150
    is_boss_chapter = boss_chapter_indices.include?(i + 1)

    chapter = Chapter.create!(
      title: "Capítulo #{i + 1}",
      description: Faker::Lorem.paragraph,
      required_experience: is_boss_chapter ? base_experience + 200 : base_experience,
      quest: quest,
      position_x: point["x"],
      position_y: point["y"]
    )

    # Boss
    if is_boss_chapter
      Boss.create!(
        name: Faker::Games::ElderScrolls.creature,
        slogan: Faker::Quotes::Shakespeare.hamlet_quote,
        description: "Um chefe no capítulo #{chapter.title}",
        required_experience: chapter.required_experience + rand(50..100),
        chapter: chapter
      )
    end
  end
end

# Characters
40.times do |i|
  experience = rand(0..10000)
  guild = i.even? ? guild_dev : guild_infra
  spec = guild.specializations.sample
  quest = guild == guild_dev ? quest_dev : quest_infra

  chapter_index = [ (experience / 150).to_i - 1, 0 ].max
  chapter_index = [ chapter_index, quest.chapters.count - 1 ].min
  current_chapter = quest.chapters.offset(chapter_index).first || quest.chapters.first

  unique_nickname = loop do
    nickname = Faker::Internet.unique.username
    break nickname unless User.exists?(nickname: nickname)
  end

  unique_email = loop do
    email = Faker::Internet.unique.email
    break email unless User.exists?(email: email)
  end


  character = User.create!(
    name: Faker::Name.name,
    nickname: unique_nickname,
    email: unique_email,
    password: 'password',
    role: :character,
    village: village,
    guild: guild,
    current_chapter: current_chapter,
    character_class: spec.character_classes.sample,
    specialization: spec,
    experience: experience,
    gold: rand(0..500),
    confirmed_at: Time.now
  )

  if user_image_files.any?
    image_path = USER_IMAGES_DIR.join(user_image_files.sample)
    character.photo.attach(io: File.open(image_path), filename: File.basename(image_path))
  end
end

# HonoraryTitles
titles = [ 'Mestre do React', 'Guru do Docker', 'Rei do Rails', 'Lorde do VD', 'Defensor dos Periféricos' ]
titles.each do |title|
  HonoraryTitle.create!(
    title: title,
    slogan: Faker::Lorem.sentence,
    character: User.where(role: :character).sample,
    narrator: narrator
  )
end

# TreasureChests
guilds = [ guild_dev, guild_infra ]

3.times do |i|
  guild = guilds.sample
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

User.where(role: :character).each do |character|
  guild_chests = TreasureChest.where(guild: character.guild)
  next if guild_chests.empty?

  chest = guild_chests.sample
  reward = chest.rewards.sample

  CharacterTreasureChest.create!(
    character: character,
    treasure_chest: chest,
    reward: reward
  )
end

# Missions e Tasks
User.where(role: :character).each do |character|
  5.times do
    Mission.create!(
      title: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph,
      status: rand(0..2),
      gold_reward: rand(50..200),
      character: character,
      narrator: narrator
    )

    2.times do
      Task.create!(
        title: Faker::Lorem.sentence,
        description: Faker::Lorem.paragraph,
        status: rand(0..2),
        experience_reward: rand(10..100),
        character: character,
        narrator: narrator
      )
    end
  end
end

puts 'Seeds criados com sucesso!'
