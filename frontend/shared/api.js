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
}

// Экспортируем экземпляр API клиента
const apiClient = new KIT8API();

export default apiClient;