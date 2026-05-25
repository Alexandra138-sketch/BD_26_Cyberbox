from django.shortcuts import render

def home(request):
    services = [
        {
            "id": "s1",
            "title": "Testes de Penetração (Pentesting)",
            "description": "Simulação de ataques reais para identificar vulnerabilidades na sua infraestrutura antes que os atacantes o façam.",
            "icon": "shield",
            "nis2Compliant": True
        },
        {
            "id": "s2",
            "title": "Gestão de Incidentes NIS2",
            "description": "Resposta rápida a incidentes de segurança com notificação às autoridades dentro dos prazos NIS2 (24h/72h).",
            "icon": "alert",
            "nis2Compliant": True
        },
        {
            "id": "s3",
            "title": "Auditoria de Conformidade NIS2",
            "description": "Avaliação completa do estado de conformidade com a Diretiva NIS2 e elaboração de planos de ação.",
            "icon": "clipboard",
            "nis2Compliant": True
        },
        {
            "id": "s4",
            "title": "SIEM & Monitorização Contínua",
            "description": "Monitorização contínua de eventos de segurança com correlação avançada de ameaças.",
            "icon": "monitor",
            "nis2Compliant": True
        },
        {
            "id": "s5",
            "title": "Formação e Consciencialização",
            "description": "Programas de formação personalizados para aumentar a maturidade de segurança das suas equipas.",
            "icon": "book",
            "nis2Compliant": False
        },
        {
            "id": "s6",
            "title": "Segurança Cloud & DevSecOps",
            "description": "Proteção de ambientes cloud e integração de segurança no ciclo de desenvolvimento de software.",
            "icon": "cloud",
            "nis2Compliant": False
        }
    ]

    home_content = {
        "hero": {
            "title": "Segurança Digital para um Mundo Conectado",
            "subtitle": "Proteja a sua empresa contra ameaças digitais e garanta conformidade com as diretivas europeias de cibersegurança."
        },
        "services": {
            "title": "Serviços Especializados",
            "subtitle": "Soluções completas para elevar a segurança e conformidade da sua empresa"
        },
        "cta": {
            "title": "Pronto para Proteger o Seu Negócio?",
            "subtitle": "Agende uma demonstração gratuita e descubra como a nossa tecnologia pode proteger a sua empresa contra ameaças digitais."
        }
    }

    return render(request, 'cyberbox/index.html', {'services': services, 'content': home_content})
