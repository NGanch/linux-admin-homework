# Використовуємо офіційний Python-образ
FROM python:3.9-slim

# Змінюємо робочу директорію
WORKDIR /app

# Копіюємо залежності
COPY requirements.txt .

# Встановлюємо залежності
RUN pip install --upgrade pip && pip install -r requirements.txt

# Копіюємо весь проєкт
COPY . .

# Запускаємо сервер
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
