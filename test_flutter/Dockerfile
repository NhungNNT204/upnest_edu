# Sử dụng image Flutter chính thức
FROM ghcr.io/cirruslabs/flutter:3.24.0

# Đặt thư mục làm việc
WORKDIR /app

# Copy toàn bộ code của project vào container
COPY . .

# Cài đặt dependencies
RUN flutter pub get

# Build ra file APK release
RUN flutter build apk --release

# Container không cần chạy server gì nên ta không cần CMD
