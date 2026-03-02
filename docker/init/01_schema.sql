CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS prediction_templates (
    id BIGSERIAL PRIMARY KEY,
    category VARCHAR(32) NOT NULL,
    text TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (category, text)
);

CREATE TABLE IF NOT EXISTS user_predictions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    template_id BIGINT NOT NULL REFERENCES prediction_templates (id) ON DELETE RESTRICT,
    category VARCHAR(32) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    day_key DATE NOT NULL
);

INSERT INTO prediction_templates (category, text)
VALUES
    ('main', 'Сегодня удача на вашей стороне!'),
    ('main', 'Впереди вас ждут приятные сюрпризы.'),
    ('main', 'Доверьтесь своей интуиции, она вас не подведет.'),
    ('main', 'Новые возможности уже на пороге.'),
    ('main', 'Сегодня идеальный день для новых начинаний.'),
    ('main', 'Ваши мечты ближе, чем вы думаете.'),
    ('main', 'Улыбнитесь — вселенная улыбается вам в ответ.'),
    ('main', 'Скоро произойдет что-то удивительное.'),
    ('love', 'Любовь витает в воздухе — будьте внимательны!'),
    ('love', 'Ваше сердце подскажет правильный путь.'),
    ('love', 'Романтический сюрприз уже в пути.'),
    ('love', 'Сегодня отличный день для признаний.'),
    ('love', 'Ваша вторая половинка думает о вас прямо сейчас.'),
    ('career', 'Ваш труд будет вознагражден в ближайшее время.'),
    ('career', 'Новые профессиональные горизонты открываются перед вами.'),
    ('career', 'Коллеги оценят вашу инициативу.'),
    ('career', 'Смелое решение приведет к успеху в карьере.'),
    ('career', 'Важная встреча изменит ваш профессиональный путь.'),
    ('health', 'Ваше здоровье в ваших руках — берегите себя.'),
    ('health', 'Прогулка на свежем воздухе зарядит вас энергией.'),
    ('health', 'Сегодня хороший день для занятий спортом.'),
    ('health', 'Обратите внимание на свой режим сна.'),
    ('health', 'Здоровый образ жизни принесет свои плоды совсем скоро.'),
    ('finance', 'Финансовое решение, принятое сегодня, окажется верным.'),
    ('finance', 'Неожиданная прибыль не за горами.'),
    ('finance', 'Время для разумных инвестиций.'),
    ('finance', 'Экономия сегодня — богатство завтра.'),
    ('finance', 'Ваши финансовые планы начинают реализовываться.')
ON CONFLICT (category, text) DO NOTHING;
