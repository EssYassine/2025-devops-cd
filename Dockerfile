# === Étape 1 : build ===
FROM eclipse-temurin:21-jdk-jammy AS build

WORKDIR /app

# Copier le wrapper Maven et le rendre exécutable
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
RUN chmod +x mvnw

# Copier le code source
COPY src src

# Build le jar sans tests pour accélérer
RUN ./mvnw clean package -DskipTests

# === Étape 2 : image finale ===
FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app

# Copier seulement le jar généré
COPY --from=build /app/target/*.jar app.jar

# Exposer le port de l'application
EXPOSE 8080

# Commande pour lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
