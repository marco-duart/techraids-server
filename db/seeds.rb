require 'faker'
Faker::Config.default_locale = :pt

User.destroy_all
Village.destroy_all
Guild.destroy_all
Specialization.destroy_all
CharacterClass.destroy_all
Task.destroy_all
Mission.destroy_all
TreasureChest.destroy_all
HonoraryTitle.destroy_all
Quest.destroy_all
Chapter.destroy_all
Boss.destroy_all
CharacterTreasureChest.destroy_all

# Village
village = Village.create!(name: 'TI', description: 'Departamento de Tecnologia da Informação')


# Narrator (Gestor)
narrator = User.create!(
  name: Faker::Name.name,
  email: 'narrator@techraids.com',
  password: 'password',
  role: :narrator,
  village: village,
  confirmed_at: Time.now
)

# # Guilds
# guild_dev = Guild.create!(name: 'Dev', description: 'Equipe de Desenvolvimento', village: village, narrator: narrator)
# guild_infra = Guild.create!(name: 'Infra', description: 'Equipe de Infraestrutura', village: village,  narrator: narrator)

# # Specializations
# specializations_dev = [
#   'Front-end', 'Back-end', 'Full-stack', 'QA', 'DevOps'
# ]
# specializations_infra = [
#   'Redes', 'Telefonia', 'Hardware'
# ]

# specializations_dev.each do |spec|
#   Specialization.create!(title: spec, description: "Especialização em #{spec}")
# end

# specializations_infra.each do |spec|
#   Specialization.create!(title: spec, description: "Especialização em #{spec}")
# end

# # CharacterClasses
# Specialization.all.each do |spec|
#   3.times do
#     CharacterClass.create!(
#       name: Faker::Job.title,
#       slogan: Faker::Lorem.sentence,
#       required_experience: rand(100..1000),
#       specialization: spec
#     )
#   end
# end

# # Characters
# 5.times do
#   User.create!(
#     name: Faker::Name.name,
#     nickname: Faker::Name.name,
#     email: Faker::Internet.email,
#     password: 'password',
#     role: 0,
#     village: village,
#     guild: guild_dev,
#     character_class: CharacterClass.where(specialization: Specialization.where(title: specializations_dev)).sample,
#     specialization: Specialization.where(title: specializations_dev).sample,
#     confirmed_at: Time.now
#   )
# end

# 5.times do
#   User.create!(
#     name: Faker::Name.name,
#     nickname: Faker::Name.name,
#     email: Faker::Internet.email,
#     password: 'password',
#     role: 0,
#     village: village,
#     guild: guild_infra,
#     character_class: CharacterClass.where(specialization: Specialization.where(title: specializations_infra)).sample,
#     specialization: Specialization.where(title: specializations_infra).sample
#   )
# end

# # Quests
# quest_dev = Quest.create!(
#   title: 'Jornada do Desenvolvedor',
#   description: 'Uma jornada épica para dominar o desenvolvimento de software.',
#   guild: guild_dev
# )

# quest_infra = Quest.create!(
#   title: 'Jornada do Infra',
#   description: 'Uma jornada desafiadora para dominar a infraestrutura de TI.',
#   guild: guild_infra
# )

# # Chapters
# [ quest_dev, quest_infra ].each do |quest|
#   100.times do |i|
#     Chapter.create!(
#       title: "Capítulo #{i + 1}",
#       description: Faker::Lorem.paragraph,
#       required_experience: (i + 1) * 100,
#       quest: quest
#     )
#   end
# end

# # Criar HonoraryTitles
# honorary_titles_dev = [
#  'Mestre do React', 'Guru do Docker', 'Rei do Rails'
# ]
# honorary_titles_infra = [
#   'Lorde do VD', 'Defensor dos Periféricos', 'Guardião da Rede'
# ]

# honorary_titles_dev.each do |title|
#   HonoraryTitle.create!(
#     title: title,
#     slogan: Faker::Lorem.sentence,
#     character: User.where(guild: guild_dev).sample
#   )
# end

# honorary_titles_infra.each do |title|
#   HonoraryTitle.create!(
#     title: title,
#     slogan: Faker::Lorem.sentence,
#     character: User.where(guild: guild_infra).sample
#   )
# end

# # TreasureChests
# 10.times do
#   TreasureChest.create!(
#     title: Faker::Games::Zelda.item,
#     value: rand(50..500)
#   )
# end

# puts 'Seeds criados com sucesso!'
