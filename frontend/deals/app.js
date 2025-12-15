// Логика модуля Сделок

// Ждем, когда DOM будет полностью загружен и apiClient будет доступен
document.addEventListener('DOMContentLoaded', async () => {
  // Ждем доступности apiClient
  const maxRetries = 20; // 20 попыток по 100мс = 2 секунды ожидания
  let retries = 0;
  while (!window.apiClient && retries < maxRetries) {
    await new Promise(resolve => setTimeout(resolve, 100));
    retries++;
  }

  if (!window.apiClient) {
    console.error('API client не загружен');
    return;
  }

  const apiClient = window.apiClient;
  // Инициализируем шапку
  const header = new KIT8Header('header-container');
  
  // Получаем элементы DOM
  const addDealBtn = document.getElementById('add-deal-btn');
  const dealModal = document.getElementById('deal-modal');
  const closeModal = document.querySelector('.close');
  const dealForm = document.getElementById('deal-form');
  const searchInput = document.getElementById('search-deals');
  
  // Открытие модального окна
  addDealBtn.addEventListener('click', () => {
    loadContactsForSelect();
    dealModal.style.display = 'block';
  });
  
  // Закрытие модального окна
  closeModal.addEventListener('click', () => {
    dealModal.style.display = 'none';
  });
  
  // Закрытие модального окна при клике вне его
  window.addEventListener('click', (event) => {
    if (event.target === dealModal) {
      dealModal.style.display = 'none';
    }
  });
  
  // Отправка формы сделки
  dealForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const title = document.getElementById('deal-title').value;
    const contactId = document.getElementById('deal-contact').value;
    const value = document.getElementById('deal-value').value;
    const stage = document.getElementById('deal-stage').value;
    
    try {
      const newDeal = await window.apiClient.post('/crm/deals/', {
        title,
        contact_id: parseInt(contactId),
        value: parseFloat(value),
        stage
      });
      
      // Добавляем новую сделку на доску
      addDealToBoard(newDeal);
      
      // Сбрасываем форму и закрываем модальное окно
      dealForm.reset();
      dealModal.style.display = 'none';
      
      // Показываем сообщение об успехе
      showMessage('Сделка успешно создана!', 'success');
    } catch (error) {
      console.error('Ошибка при создании сделки:', error);
      showMessage('Ошибка при создании сделки', 'error');
    }
  });
  
  // Функция загрузки контактов для выпадающего списка
  async function loadContactsForSelect() {
    try {
      const contacts = await window.apiClient.get('/crm/contacts');
      const contactSelect = document.getElementById('deal-contact');
      
      // Очищаем текущие опции
      contactSelect.innerHTML = '';
      
      // Добавляем новые опции
      contacts.forEach(contact => {
        const option = document.createElement('option');
        option.value = contact.id;
        option.textContent = contact.name || contact.email;
        contactSelect.appendChild(option);
      });
    } catch (error) {
      console.error('Ошибка при загрузке контактов:', error);
    }
  }
  
  // Функция добавления сделки на доску
  function addDealToBoard(deal) {
    let stageId;
    switch(deal.stage) {
      case 'new':
        stageId = 'deals-new';
        break;
      case 'in-progress':
        stageId = 'deals-in-progress';
        break;
      case 'won':
        stageId = 'deals-won';
        break;
      case 'lost':
        stageId = 'deals-lost';
        break;
      default:
        stageId = `deals-${deal.stage}`;
    }
    
    const stageContainer = document.querySelector(`#${stageId}`);
    if (!stageContainer) return;
    
    const dealCard = createDealCard(deal);
    stageContainer.appendChild(dealCard);
  }
  
  // Функция создания карточки сделки
  function createDealCard(deal) {
    const card = document.createElement('div');
    card.className = 'deal-card';
    card.dataset.id = deal.id;
    
    card.innerHTML = `
      <h4>${deal.title}</h4>
      <p>Сумма: <span class="deal-value">${deal.value} ₽</span></p>
      <p>Контакт: ${deal.contact?.name || deal.contact?.email || 'Не указан'}</p>
    `;
    
    // Добавляем обработчик клика для редактирования
    card.addEventListener('click', () => {
      editDeal(deal.id);
    });
    
    return card;
  }
  
  // Функция редактирования сделки
  async function editDeal(id) {
    // В реальном приложении здесь будет логика редактирования
    console.log(`Редактирование сделки с ID: ${id}`);
    
    // Показываем модальное окно с формой редактирования
    // (в этой версии просто показываем сообщение)
    showMessage('Функция редактирования сделки в разработке', 'info');
  }
  
  // Функция загрузки и отображения всех сделок
  async function loadDeals() {
    try {
      const deals = await window.apiClient.get('/crm/deals');
      
      // Очищаем все доски
      document.querySelectorAll('.deals-list').forEach(list => {
        list.innerHTML = '';
      });
      
      // Добавляем каждую сделку на соответствующую доску
      deals.forEach(deal => {
        addDealToBoard(deal);
      });
    } catch (error) {
      console.error('Ошибка при загрузке сделок:', error);
      showMessage('Ошибка при загрузке сделок', 'error');
    }
  }
  
  // Функция поиска сделок
  searchInput.addEventListener('input', () => {
    const searchTerm = searchInput.value.toLowerCase();
    
    // Скрываем все карточки
    document.querySelectorAll('.deal-card').forEach(card => {
      card.style.display = 'none';
    });
    
    // Показываем только те, которые соответствуют поисковому запросу
    document.querySelectorAll('.deal-card').forEach(card => {
      const title = card.querySelector('h4').textContent.toLowerCase();
      if (title.includes(searchTerm)) {
        card.style.display = 'block';
      }
    });
  });
  
  // Показ сообщений пользователю
  function showMessage(message, type) {
    // Создаем элемент сообщения
    const messageEl = document.createElement('div');
    messageEl.className = `message message-${type}`;
    messageEl.textContent = message;
    messageEl.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      padding: 1rem;
      border-radius: 4px;
      color: white;
      z-index: 1002;
      ${type === 'success' ? 'background-color: #10b981;' : 
        type === 'error' ? 'background-color: #ef4444;' : 
        'background-color: #3b82f6;'}
    `;
    
    document.body.appendChild(messageEl);
    
    // Удаляем сообщение через 3 секунды
    setTimeout(() => {
      messageEl.remove();
    }, 3000);
  }
  
  // Загружаем сделки при инициализации
  loadDeals();
});