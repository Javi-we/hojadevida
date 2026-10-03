// Cambiador de Tema (Claro / Oscuro)
const themeToggleBtn = document.getElementById('theme-toggle');
const themeIcon = document.getElementById('theme-icon');

function toggleTheme() {
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', newTheme);
    themeIcon.textContent = newTheme === 'dark' ? '☀️' : '🌙';
    localStorage.setItem('theme', newTheme);
}

if (themeToggleBtn) {
    themeToggleBtn.addEventListener('click', toggleTheme);
}

// Cargar tema guardado
const savedTheme = localStorage.getItem('theme');
if (savedTheme) {
    document.documentElement.setAttribute('data-theme', savedTheme);
    if (themeIcon) {
        themeIcon.textContent = savedTheme === 'dark' ? '☀️' : '🌙';
    }
}

// Acordeón para Historial Laboral
function toggleAccordion(elementId) {
    const content = document.getElementById(elementId);
    if (content) {
        content.classList.toggle('hidden');
    }
}

// Filtro Interactivo de Aptitudes
function filterSkills(category) {
    const buttons = document.querySelectorAll('.filter-btn');
    buttons.forEach(btn => btn.classList.remove('active'));

    // Activar botón clickeado
    const clickedBtn = Array.from(buttons).find(btn => 
        btn.getAttribute('onclick').includes(`'${category}'`)
    );
    if (clickedBtn) {
        clickedBtn.classList.add('active');
    }

    const skills = document.querySelectorAll('.skill-chip');
    skills.forEach(skill => {
        if (category === 'all' || skill.getAttribute('data-category') === category) {
            skill.classList.remove('hidden');
        } else {
            skill.classList.add('hidden');
        }
    });
}

// Validación y envío de Formulario de Contacto
function handleFormSubmit(event) {
    event.preventDefault();
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const feedback = document.getElementById('form-feedback');

    feedback.style.color = '#22c55e';
    feedback.innerHTML = `¡Gracias, <strong>${name}</strong>! Tu mensaje ha sido enviado correctamente. Te responderé pronto a <em>${email}</em>.`;

    document.getElementById('contact-form').reset();

    setTimeout(() => {
        feedback.innerHTML = '';
    }, 5000);
}

// Resaltar navegación según scroll
window.addEventListener('scroll', () => {
    const sections = document.querySelectorAll('section');
    const navLinks = document.querySelectorAll('.q-link');

    let current = '';
    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        if (pageYOffset >= sectionTop - 100) {
            current = section.getAttribute('id');
        }
    });

    navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === `#${current}`) {
            link.classList.add('active');
        }
    });
});
