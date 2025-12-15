// Единый API клиент для всех модулей KIT8 Platform

class KIT8API {
  constructor(baseURL = '/api') {
    this.baseURL = baseURL;
    this.defaultHeaders = {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${localStorage.getItem('token') || ''}`
    };
  }

  // Общий метод для выполнения запросов
  async request(endpoint, options = {}) {
    const url = `${this.baseURL}${endpoint}`;
    const config = {
      headers: { ...this.defaultHeaders, ...options.headers },
      ...options
    };

    // Добавляем токен авторизации, если он есть
    const token = localStorage.getItem('token');
    if (token && !config.headers.Authorization) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    try {
      const response = await fetch(url, config);
      
      // Обработка ошибок
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const data = await response.json();
      return data;
    } catch (error) {
      console.error('API request error:', error);
      throw error;
    }
  }

  // GET запрос
  async get(endpoint, params = {}) {
    const queryString = new URLSearchParams(params).toString();
    const url = queryString ? `${endpoint}?${queryString}` : endpoint;
    return this.request(url, { method: 'GET' });
  }

  // POST запрос
  async post(endpoint, data) {
    return this.request(endpoint, {
      method: 'POST',
      body: JSON.stringify(data)
    });
  }

  // PUT запрос
  async put(endpoint, data) {
    return this.request(endpoint, {
      method: 'PUT',
      body: JSON.stringify(data)
    });
  }

  // DELETE запрос
  async delete(endpoint) {
    return this.request(endpoint, { method: 'DELETE' });
  }

  // Метод для авторизации
  async login(credentials) {
    try {
      const response = await fetch(`${this.baseURL}/auth/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(credentials)
      });

      if (!response.ok) {
        throw new Error('Login failed');
      }

      const data = await response.json();
      localStorage.setItem('token', data.token);
      return data;
    } catch (error) {
      console.error('Login error:', error);
      throw error;
    }
  }

  // Метод для выхода
  logout() {
    localStorage.removeItem('token');
  }

  // Метод для проверки авторизации
  isAuthenticated() {
    const token = localStorage.getItem('token');
    return !!token;
  }

  // Простое кэширование
  cache = new Map();
  
  async getCached(endpoint, params = {}, ttl = 60000) { // TTL по умолчанию 1 минута
    const cacheKey = `${endpoint}?${new URLSearchParams(params).toString()}`;
    const cached = this.cache.get(cacheKey);
    
    if (cached && Date.now() - cached.timestamp < ttl) {
      return cached.data;
    }
    
    const data = await this.get(endpoint, params);
    this.cache.set(cacheKey, {
      data: data,
      timestamp: Date.now()
    });
    
    return data;
  }

  // Методы для CRM
  async getContacts() {
    return this.get('/crm/contacts');
  }

  async createContact(contactData) {
    return this.post('/crm/contacts', contactData);
  }

  async updateContact(id, contactData) {
    return this.put(`/crm/contacts/${id}`, contactData);
  }

  async deleteContact(id) {
    return this.delete(`/crm/contacts/${id}`);
 }

  async getContactDeals(contactId) {
    return this.get(`/crm/contacts/${contactId}/deals`);
  }

  async getCRMStats() {
    return this.get('/crm/stats');
  }

  // Методы для сделок
  async getDeals() {
    return this.get('/crm/deals');
  }

  async createDeal(dealData) {
    return this.post('/crm/deals', dealData);
  }

  async updateDeal(id, dealData) {
    return this.put(`/crm/deals/${id}`, dealData);
  }

  async deleteDeal(id) {
    return this.delete(`/crm/deals/${id}`);
  }

  async getDealStats() {
    return this.get('/crm/deals/stats');
  }

  // Методы для других модулей
  async getInventoryStats() {
    return this.get('/inventory/stats');
  }

  async getOrderStats() {
    return this.get('/orders/stats');
  }

  async getCashierStats() {
    return this.get('/cashier/stats');
  }

  // Platform методы
  async getPlatformStatus() {
    return this.get('/health');
  }
}

// Экспортируем экземпляр API клиента
const apiClient = new KIT8API();

export default apiClient;