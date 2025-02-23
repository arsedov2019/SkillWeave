# README

## Тестовое задание – Седов Артем

### Создание проекта
Генерируем новое Rails-приложение:
```sh
rails new SkillWeave
```

### Установка необходимых гемов
Добавляем в `Gemfile`:
```ruby
gem 'active_interaction'
gem 'rspec-rails'
```

### Генерация моделей и миграций
Создаем модели и миграции для следующих таблиц: `users`, `interests`, `skills`, `user_interests`, `user_skills`.

#### Модель `User`
**Поля:**
- `full_name:string`
- `email:string`
- `age:integer`
- `nationality:string`
- `country:string`
- `gender:string`

**Связи:**
```ruby
has_many :user_interests
has_many :interests, through: :user_interests
has_many :user_skills
has_many :skills, through: :user_skills
```

**Валидации:**
- `age` должно быть числом больше 0 и меньше или равно 90.
- `gender` должно принимать значения только из списка `['male', 'female']`.

#### Модель `Interest`
**Поля:**
- `name:string`

**Связи:**
```ruby
has_many :user_interests
has_many :users, through: :user_interests
```

#### Модель `Skill`
**Поля:**
- `name:string`

**Связи:**
```ruby
has_many :user_skills
has_many :users, through: :user_skills
```

#### Модель `UserInterest`
**Связи:**
```ruby
belongs_to :user
belongs_to :interest
```

#### Модель `UserSkill`
**Связи:**
```ruby
belongs_to :user
belongs_to :skill
```

### Рефакторинг `Users::Create`

**Определены входные параметры:**
```ruby
string :name, required: true
string :patronymic, required: false
string :email, required: true
integer :age, required: true, greater_than: 0, less_than_or_equal_to: 90
string :nationality, required: true
string :country, required: true
string :gender, required: true, inclusion: { in: ['male', 'female'] }
string :surname, required: true
array :interests, default: nil
string :skills, default: nil
```

**Валидация:**
- Проверка уникальности email через метод `email_uniqueness`.

**Метод `execute` выполняет следующие шаги:**
1. Формирует полное имя пользователя.
2. Создает объект `User` с параметрами.
3. Проверяет валидность объекта `User`.
4. Сохраняет пользователя в базе данных, если все валидации пройдены.
5. Добавляет интересы и навыки к пользователю.
6. Возвращает созданного пользователя или объект с ошибками.

### Исправление ошибок

#### Исправлена опечатка `Skil` на `Skill`
**Исправления:**
1. Переименование `Skil` в `Skill`.
2. Обновление всех ссылок на этот класс в коде.
3. Переименование файла модели с `skil.rb` на `skill.rb`.
4. Обновление миграций (`skils` → `skills`).
5. Исправление всех тестов и кода, где использовался `Skil`.

> **Альтернативный вариант:** пу пу пу  Если проект уже на продакшене с большой базой данных, и изменение имени таблицы слишком рискованно, `Skil` можно оставить без изменений.

#### Исправлены ассоциации
- Настроены отношения `многие ко многим` через промежуточные таблицы `user_interests` и `user_skills`.

### Найденные ошибки и их исправления

1. **Ошибка в проверке пола:**
```ruby
return if params['gender'] != 'male' or params['gender'] != 'female'
```
_Проблема:_ Всегда возвращает `true`, так как `gender` не может быть одновременно `male` и `female`.

_Исправление:_
```ruby
return if params['gender'] != 'male' and params['gender'] != 'female'
```

2. **Ошибка в `merge` данных пользователя:**
```ruby
user = User.create(user_params.merge(user_full_name))
```
_Проблема:_ `merge` вызовет ошибку, так как `user_full_name` — это строка.

_Исправление:_
```ruby
user = User.create(user_params.merge(user_full_name: user_full_name))
```

3. **Ошибка в названии модели:**
```ruby
Intereset.where(name: params['interests']).each do |interest|
```
_Проблема:_ `Intereset` не существует в рамках нашего приложения.

_Исправление:_
```ruby
Interest.where(name: params['interests']).each do |interest|
```

4. **Ошибка в присваивании интересов:**
```ruby
user.interests = user.interest + interest
```
_Проблема:_ `interest` → `interests`.

_Исправление:_
```ruby
user.interests = user.interests + interests
```

