# Use an official Flutter runtime as a parent image
FROM cirrusci/flutter:2.5.3

# Set the working directory to the app path
WORKDIR /app

# Copy the pubspec.yaml and pubspec.lock files to the container
COPY pubspec.yaml pubspec.lock ./

# Install the app dependencies
RUN flutter pub get

# Copy the entire project to the container
COPY . .

# Build the Flutter app
RUN flutter build web

# Expose the port the app runs on
EXPOSE 8080

# Define the command to run your app
CMD ["flutter", "run", "--release", "--no-sound-null-safety"]
