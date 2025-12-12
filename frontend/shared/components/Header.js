// Компонент шапки для всех модулей KIT8 Platform

class KIT8Header {
  constructor(containerId) {
    this.container = document.getElementById(containerId);
    this.modules = [
      { name: 'CRM', path: '/crm/', icon: '📞' },
      { name: 'Сделки', path: '/deals/', icon: '💼' },
      { name: 'Склад', path: '/inventory/', icon: '📦' },
      { name: 'Заказы', path: '/orders/', icon: '🛒' },
      { name: 'Касса', path: '/cashier/', icon: '💳' }
    ];
    this.render();
    this.addEventListeners();
  }

  render() {
    const isLoggedIn = this.isAuthenticated();
    const user = this.getCurrentUser();

    this.container.innerHTML = `
      <header class="kit8-header">
        <div class="header-container">
          <div class="logo-section">
            <a href="/" class="logo-link">
              <div class="logo-animation">
                <span class="whale-logo">🐋</span>
                <h1>KIT8</h1>
              </div>
            </a>
          </div>
          
          <nav class="main-nav">
            <ul class="nav-menu">
              ${isLoggedIn ? this.renderNavItems() : ''}
            </ul>
          </nav>
          
          <div class="user-section">
            ${isLoggedIn ? this.renderUserInfo(user) : this.renderAuthButtons()}
          </div>
        </div>
      </header>
      
      <style>
        .kit8-header {
          background-color: #1E3A8A; /* Синий океана */
          color: white;
          padding: 0.5rem 0;
          position: sticky;
          top: 0;
          z-index: 1000;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .header-container {
          max-width: 1200px;
          margin: 0 auto;
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding: 0 1rem;
        }
        
        .logo-section .logo-link {
          text-decoration: none;
          display: flex;
          align-items: center;
        }
        
        .logo-animation {
          display: flex;
          align-items: center;
          animation: float 3s ease-in-out infinite;
        }
        
        @keyframes float {
          0% { transform: translateY(0px); }
          50% { transform: translateY(-5px); }
          100% { transform: translateY(0px); }
        }
        
        .whale-logo {
          font-size: 2rem;
          margin-right: 0.5rem;
        }
        
        .logo-section h1 {
          color: white;
          margin: 0;
          font-size: 1.5rem;
        }
        
        .nav-menu {
          display: flex;
          list-style: none;
          margin: 0;
          padding: 0;
          gap: 1rem;
        }
        
        .nav-menu li {
          position: relative;
        }
        
        .nav-menu a {
          color: white;
          text-decoration: none;
          padding: 0.5rem 1rem;
          border-radius: 4px;
          transition: background-color 0.3s;
          display: flex;
          align-items: center;
          gap: 0.5rem;
        }
        
        .nav-menu a:hover {
          background-color: rgba(255, 255, 255, 0.1);
        }
        
        .user-section .user-info,
        .user-section .auth-buttons {
          display: flex;
          align-items: center;
          gap: 1rem;
        }
        
        .user-dropdown {
          position: relative;
        }
        
        .dropdown-content {
          display: none;
          position: absolute;
          right: 0;
          background-color: white;
          min-width: 160px;
          box-shadow: 0px 8px 16px rgba(0,0,0,0.2);
          z-index: 1001;
          border-radius: 4px;
          overflow: hidden;
        }
        
        .user-dropdown:hover .dropdown-content {
          display: block;
        }
        
        .dropdown-content a {
          color: black;
          padding: 12px 16px;
          text-decoration: none;
          display: block;
        }
        
        .dropdown-content a:hover {
          background-color: #f1f1f1;
        }
        
        .btn {
          padding: 0.5rem 1rem;
          border-radius: 4px;
          border: none;
          cursor: pointer;
          text-decoration: none;
          display: inline-block;
          text-align: center;
          transition: background-color 0.3s;
        }
        
        .btn-primary {
          background-color: #F97316; /* Оранжевый акцент */
          color: white;
        }
        
        .btn-primary:hover {
          background-color: #ea580c;
        }
        
        .btn-secondary {
          background-color: transparent;
          color: white;
          border: 1px solid white;
        }
        
        .btn-secondary:hover {
          background-color: rgba(255, 255, 255, 0.1);
        }
        
        @media (max-width: 768px) {
          .header-container {
            flex-direction: column;
            gap: 1rem;
            padding: 0 0.5rem;
          }
          
          .nav-menu {
            width: 100%;
            justify-content: center;
          }
        }
      </style>
    `;
  }

  renderNavItems() {
    return this.modules.map(module => `
      <li><a href="${module.path}">
        <span>${module.icon}</span>
        <span>${module.name}</span>
      </a></li>
    `).join('');
  }

  renderUserInfo(user) {
    return `
      <div class="user-section">
        <div class="user-dropdown">
          <button class="btn btn-secondary">${user.name || user.email}</button>
          <div class="dropdown-content">
            <a href="/profile/">Профиль</a>
            <a href="#" id="logout-btn">Выход</a>
          </div>
        </div>
      </div>
    `;
  }

  renderAuthButtons() {
    return `
      <div class="auth-buttons">
        <a href="/login/" class="btn btn-secondary">Вход</a>
        <a href="/register/" class="btn btn-primary">Регистрация</a>
      </div>
    `;
  }

  addEventListeners() {
    const logoutBtn = this.container.querySelector('#logout-btn');
    if (logoutBtn) {
      logoutBtn.addEventListener('click', (e) => {
        e.preventDefault();
        this.logout();
        this.render(); // Перерендер после выхода
      });
    }
  }

  isAuthenticated() {
    // Проверяем наличие токена в localStorage
    const token = localStorage.getItem('token');
    return !!token;
  }

  getCurrentUser() {
    // В реальном приложении здесь будет декодирование JWT токена
    // или получение информации о пользователе из API
    const token = localStorage.getItem('token');
    if (token) {
      try {
        // Простая демонстрация - в реальном приложении использовать JWT декодирование
        return { email: 'user@example.com', name: 'Имя Пользователя' };
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  logout() {
    // Вызываем метод logout из api клиента
    localStorage.removeItem('token');
    // Перенаправляем на главную страницу
    window.location.href = '/';
  }
}

// Экспортируем класс для использования в других модулях
export default KIT8Header;