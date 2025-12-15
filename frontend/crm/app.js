// frontend/crm/app.js

class KIT8CRM {
    constructor() {
        this.currentContacts = [];
        this.init();
    }

    init() {
        this.bindEvents();
        this.loadContacts();
    }

    getApi() {
        // Проверяем, доступен ли apiClient через window
        if (window.apiClient) {
            return window.apiClient;
        } else {
            console.error('API client not found. Please ensure shared/api.js is loaded.');
            return null;
        }
    }

    bindEvents() {
        // Добавление контакта
        const addBtn = document.getElementById('add-contact-btn');
        if (addBtn) {
            addBtn.addEventListener('click', () => this.addContact());
        }

        // Обновление списка
        const refreshBtn = document.getElementById('refresh-contacts');
        if (refreshBtn) {
            refreshBtn.addEventListener('click', () => this.loadContacts());
        }

        // Обработка Enter в форме
        document.addEventListener('keypress', (e) => {
            if (e.key === 'Enter' && e.target.closest('.add-contact-form')) {
                this.addContact();
            }
        });
    }

    async loadContacts() {
        const container = document.getElementById('contacts-container');
        if (!container) return;

        container.innerHTML = `
            <div class="loading">
                <div class="loading-spinner"></div>
                <p>Загрузка контактов...</p>
            </div>
        `;

        try {
            const data = await this.getApi().getContacts();
            
            if (data.success) {
                this.currentContacts = data.data;
                this.renderContacts(this.currentContacts);
                await this.loadStats();
            } else {
                this.showError(container, 'Ошибка при загрузке контактов');
            }
        } catch (error) {
            console.error('Ошибка загрузки контактов:', error);
            this.showError(container, 'Не удалось загрузить контакты');
        }
    }

    renderContacts(contacts) {
        const container = document.getElementById('contacts-container');
        if (!container) return;

        if (contacts.length === 0) {
            container.innerHTML = `
                <div class="loading">
                    <p>Контактов пока нет</p>
                    <p style="font-size: 0.9rem; color: #6B7280; margin-top: 10px;">
                        Добавьте первый контакт используя форму справа
                    </p>
                </div>
            `;
            return;
        }

        let html = '<div class="contacts-list">';

        contacts.forEach(contact => {
            html += this.createContactCardHTML(contact);
        });

        html += '</div>';
        container.innerHTML = html;

        // Привязываем события клика на карточки
        setTimeout(() => this.bindContactCardEvents(), 0);
    }

    createContactCardHTML(contact) {
        const firstLetter = contact.first_name ? contact.first_name.charAt(0).toUpperCase() : '?';
        const phoneFormatted = contact.phone ? 
            contact.phone.replace(/(\d{1})(\d{3})(\d{3})(\d{2})(\d{2})/, '+$1 ($2) $3-$4-$5') : 
            'Нет телефона';
        
        const tagsHtml = contact.tags && contact.tags.length > 0
            ? contact.tags.map(tag => {
                const tagClass = tag === 'новый' ? 'new' : tag === 'VIP' || tag === 'важный' ? 'vip' : '';
                return `<span class="tag ${tagClass}">${tag}</span>`;
            }).join('')
            : '';

        const date = new Date(contact.created_at);
        const formattedDate = date.toLocaleDateString('ru-RU', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric'
        });

        return `
            <div class="contact-card" data-contact-id="${contact.id}">
                <div class="contact-avatar">${firstLetter}</div>
                <div class="contact-info">
                    <div class="contact-name">
                        ${contact.first_name} ${contact.last_name || ''}
                    </div>
                    <div class="contact-details">
                        <div class="contact-detail">
                            <span>📧</span> ${contact.email}
                        </div>
                        <div class="contact-detail">
                            <span>📱</span> ${phoneFormatted}
                        </div>
                        <div class="contact-detail">
                            <span>🏢</span> ${contact.company || 'Нет компании'}
                        </div>
                        <div class="contact-detail">
                            <span>📅</span> ${formattedDate}
                        </div>
                    </div>
                    <div class="contact-tags">
                        ${tagsHtml}
                    </div>
                </div>
            </div>
        `;
    }

    bindContactCardEvents() {
        document.querySelectorAll('.contact-card').forEach(card => {
            card.addEventListener('click', (e) => {
                const contactId = card.getAttribute('data-contact-id');
                const contact = this.currentContacts.find(c => c.id == contactId);
                if (contact) {
                    this.openEditModal(contact);
                }
            });
        });
    }

    async addContact() {
        const firstName = document.getElementById('first-name').value.trim();
        const lastName = document.getElementById('last-name').value.trim();
        const email = document.getElementById('email').value.trim();
        const phone = document.getElementById('phone').value.trim();
        const company = document.getElementById('company').value.trim();
        const position = document.getElementById('position').value.trim();

        if (!firstName || !email) {
            this.showMessage('Пожалуйста, заполните обязательные поля (Имя и Email)', 'error');
            return;
        }

        const button = document.getElementById('add-contact-btn');
        const originalText = button.innerHTML;
        button.innerHTML = '<span>⏳</span> Добавляем...';
        button.disabled = true;

        try {
            const data = await this.getApi().createContact({
                first_name: firstName,
                last_name: lastName,
                email: email,
                phone: phone,
                company: company,
                position: position
            });

            if (data.success) {
                this.showMessage('Контакт успешно добавлен!', 'success');
                
                // Очищаем форму
                ['first-name', 'last-name', 'email', 'phone', 'company', 'position'].forEach(id => {
                    document.getElementById(id).value = '';
                });

                // Перезагружаем контакты
                setTimeout(() => this.loadContacts(), 1000);
            } else {
                this.showMessage('Ошибка: ' + (data.error || 'Неизвестная ошибка'), 'error');
            }
        } catch (error) {
            console.error('Ошибка добавления контакта:', error);
            this.showMessage('Не удалось добавить контакт', 'error');
        } finally {
            button.innerHTML = originalText;
            button.disabled = false;
        }
    }

    async loadStats() {
        try {
            const data = await this.getApi().getCRMStats();
            
            if (data.success) {
                document.getElementById('contacts-count').textContent = data.data.contacts;
                document.getElementById('deals-count').textContent = data.data.deals;

                const totalRevenue = data.data.dealsByStage?.reduce((sum, stage) => {
                    return sum + (stage.total_amount || 0);
                }, 0) || 0;

                document.getElementById('revenue-count').textContent =
                    new Intl.NumberFormat('ru-RU', {
                        style: 'currency',
                        currency: 'RUB',
                        maximumFractionDigits: 0
                    }).format(totalRevenue);
            }
        } catch (error) {
            console.error('Ошибка загрузки статистики:', error);
        }
    }

    showMessage(text, type) {
        const messageDiv = document.getElementById('form-message');
        if (!messageDiv) return;

        messageDiv.innerHTML = `
            <div class="${type === 'error' ? 'error' : 'success'}">
                ${text}
            </div>
        `;

        setTimeout(() => {
            messageDiv.innerHTML = '';
        }, 5000);
    }

    showError(container, text) {
        container.innerHTML = `
            <div class="error">
                <strong>Ошибка:</strong> ${text}
                <button class="btn" onclick="window.crmApp.loadContacts()" style="margin-top: 10px;">
                    Попробовать снова
                </button>
            </div>
        `;
    }

    // Методы для модального окна редактирования
    openEditModal(contact) {
        // Заполняем форму
        document.getElementById('edit-contact-id').value = contact.id;
        document.getElementById('edit-first-name').value = contact.first_name || '';
        document.getElementById('edit-last-name').value = contact.last_name || '';
        document.getElementById('edit-email').value = contact.email || '';
        document.getElementById('edit-phone').value = contact.phone || '';
        document.getElementById('edit-company').value = contact.company || '';
        document.getElementById('edit-position').value = contact.position || '';
        document.getElementById('edit-tags').value = contact.tags ? contact.tags.join(', ') : '';

        // Показываем модальное окно
        document.getElementById('edit-modal').style.display = 'flex';
        this.loadContactDeals(contact.id);
    }

    closeEditModal() {
        document.getElementById('edit-modal').style.display = 'none';
        document.getElementById('edit-form-message').innerHTML = '';
    }

    async saveContactChanges() {
        const contactId = document.getElementById('edit-contact-id').value;
        const firstName = document.getElementById('edit-first-name').value.trim();
        const lastName = document.getElementById('edit-last-name').value.trim();
        const email = document.getElementById('edit-email').value.trim();
        const phone = document.getElementById('edit-phone').value.trim();
        const company = document.getElementById('edit-company').value.trim();
        const position = document.getElementById('edit-position').value.trim();
        const tags = document.getElementById('edit-tags').value.trim();

        if (!firstName || !email) {
            this.showEditMessage('Имя и Email обязательны для заполнения', 'error');
            return;
        }

        const tagsArray = tags ? tags.split(',').map(tag => tag.trim()).filter(tag => tag) : [];

        const saveBtn = document.getElementById('save-contact-btn');
        const originalText = saveBtn.innerHTML;
        saveBtn.innerHTML = '<span>⏳</span> Сохраняем...';
        saveBtn.disabled = true;

        try {
            const data = await this.getApi().updateContact(contactId, {
                first_name: firstName,
                last_name: lastName,
                email: email,
                phone: phone,
                company: company,
                position: position,
                tags: tagsArray
            });

            if (data.success) {
                this.showEditMessage('Контакт успешно обновлен!', 'success');
                setTimeout(() => {
                    this.closeEditModal();
                    this.loadContacts();
                }, 1500);
            } else {
                this.showEditMessage('Ошибка: ' + (data.error || 'Неизвестная ошибка'), 'error');
            }
        } catch (error) {
            console.error('Ошибка обновления контакта:', error);
            this.showEditMessage('Не удалось обновить контакт', 'error');
        } finally {
            saveBtn.innerHTML = originalText;
            saveBtn.disabled = false;
        }
    }

    async deleteContact() {
        const contactId = document.getElementById('edit-contact-id').value;
        const contactName = document.getElementById('edit-first-name').value + ' ' + 
                           document.getElementById('edit-last-name').value;

        if (!confirm(`Удалить контакт "${contactName}"?`)) {
            return;
        }

        try {
            const data = await this.getApi().deleteContact(contactId);

            if (data.success) {
                this.showEditMessage('Контакт успешно удален!', 'success');
                setTimeout(() => {
                    this.closeEditModal();
                    this.loadContacts();
                }, 1500);
            } else {
                this.showEditMessage('Ошибка: ' + (data.error || 'Не удалось удалить контакт'), 'error');
            }
        } catch (error) {
            console.error('Ошибка удаления контакта:', error);
            this.showEditMessage('Не удалось удалить контакт', 'error');
        }
    }

    async loadContactDeals(contactId) {
        const dealsContainer = document.getElementById('contact-deals');
        if (!dealsContainer) return;

        dealsContainer.innerHTML = '<p style="color: #6B7280; text-align: center;">Загрузка сделок...</p>';

        try {
            const data = await this.getApi().getContactDeals(contactId);

            if (data.success && data.data.length > 0) {
                let html = '<h4 style="margin-bottom: 15px; color: #4B5563;">Сделки контакта:</h4>';

                data.data.forEach(deal => {
                    const amount = new Intl.NumberFormat('ru-RU', {
                        style: 'currency',
                        currency: 'RUB',
                        maximumFractionDigits: 0
                    }).format(deal.amount || 0);

                    const date = deal.expected_close_date
                        ? new Date(deal.expected_close_date).toLocaleDateString('ru-RU')
                        : 'Не указана';

                    html += `
                        <div style="background: #F3F4F6; padding: 10px 15px; border-radius: 8px; margin-bottom: 10px;">
                            <div style="font-weight: 600; color: #1F2937;">${deal.title}</div>
                            <div style="display: flex; justify-content: space-between; font-size: 0.9rem; color: #6B7280; margin-top: 5px;">
                                <span>${amount}</span>
                                <span>${deal.stage} (${deal.probability}%)</span>
                                <span>Закрытие: ${date}</span>
                            </div>
                        </div>
                    `;
                });

                dealsContainer.innerHTML = html;
            } else {
                dealsContainer.innerHTML = '<p style="color: #6B7280; text-align: center;">У контакта пока нет сделок</p>';
            }
        } catch (error) {
            console.error('Ошибка загрузки сделок:', error);
            dealsContainer.innerHTML = '<p style="color: #EF4444; text-align: center;">Ошибка загрузки сделок</p>';
        }
    }

    showEditMessage(text, type) {
        const messageDiv = document.getElementById('edit-form-message');
        if (!messageDiv) return;

        messageDiv.innerHTML = `
            <div class="${type === 'error' ? 'error' : 'success'}" style="margin: 15px 0;">
                ${text}
            </div>
        `;
    }
}

// Инициализация при загрузке страницы
document.addEventListener('DOMContentLoaded', () => {
    window.crmApp = new KIT8CRM();
    
    // Обновляем каждые 30 секунд
    setInterval(() => window.crmApp.loadContacts(), 30000);
});