CI/CD для Django-застосунку з використанням Terraform, Jenkins, Argo CD та ECR
Як застосувати Terraform
cd lesson-8-9
terraform init
terraform apply
Terraform створює повну інфраструктуру в AWS:

VPC, підмережі, Internet Gateway
EKS кластер
ECR репозиторій
Jenkins та Argo CD, встановлені через Helm
Після завершення terraform apply виконайте:

terraform output
Це дозволить отримати:

URL Jenkins
URL Argo CD
Паролі до облікових записів
Як перевірити Jenkins job
Отримайте URL Jenkins:
terraform output jenkins_url
Зробіть порт-форвардинг або перейдіть за LoadBalancer URL:
kubectl port-forward svc/jenkins -n jenkins 8080:8080
Перейдіть в браузері на http://localhost:8080

Отримайте admin-пароль Jenkins:
kubectl get secret jenkins -n jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
Створіть нову pipeline job і вкажіть шлях до Jenkinsfile, який має бути у вашому Django-репозиторії

При запуску pipeline виконається:

Збірка Docker-образу за допомогою Kaniko
Push у Amazon ECR
Оновлення charts/django-app/values.yaml (з новим тегом)
Git push змін у репозиторій Helm
Як побачити результат в Argo CD
Отримайте URL Argo CD:
terraform output argocd_url
Зробіть порт-форвардинг (якщо потрібен):
kubectl port-forward svc/argo-cd-argocd-server -n argocd 8081:443
Перейдіть в браузері на https://localhost:8081

Отримайте логін/пароль:
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
Логін: admin

Після входу ви побачите application django-app, створене на основі Helm chart. Argo CD автоматично відслідковує зміни в Git та оновлює кластер.
Схема CI/CD
Developer Push (Jenkinsfile + Dockerfile)
           ↓
      Jenkins (Pipeline)
           ↓
     Build Docker Image (Kaniko)
           ↓
      Push to ECR
           ↓
Update Helm values.yaml + Git Push
           ↓
      Argo CD Git Watcher
           ↓
    Auto-sync to EKS via Helm chart
Проєкт відповідає вимогам повноцінного GitOps-підходу: автоматичне створення інфраструктури, CI/CD pipeline, та розгортання без ручного втручання.