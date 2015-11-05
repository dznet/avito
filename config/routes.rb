Rails.application.routes.draw do
  # Главная страница приложения. Список всех объявлений.
  root 'items#index'

  # Методы для работы с объявлениями
  resources :items do
    # Запуск парсинга объявлений
    post 'parsing', on: :collection
  end
end
