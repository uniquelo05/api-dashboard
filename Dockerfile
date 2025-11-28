# SỬ DỤNG CÚ PHÁP BUILDER ĐA TẦNG
# Stage 1: builder (Dùng để cài đặt dependencies và build ứng dụng)
FROM node:20-alpine AS builder

WORKDIR /app

# [1] Cài đặt dependencies
# Chỉ copy file lock và package.json để tận dụng Docker cache hiệu quả
COPY package*.json ./
# Dùng npm ci thay vì npm install
RUN npm ci

# [2] Copy source files và Build
COPY tsconfig.json ./
COPY src ./src
# Build ứng dụng
RUN npm run build

# [3] Tối ưu hóa: Xóa dependencies không cần thiết sau khi build xong
# npm prune --production sẽ giữ lại các dependencies cần thiết cho runtime
RUN npm prune --production


# Stage 2: production (Chỉ chứa các file cần thiết để chạy ứng dụng)
FROM node:20-alpine

# [1] Tạo non-root user và group
# Sử dụng một RUN duy nhất để tạo user/group và giảm layer
# -S: Không tạo thư mục home
# -u 1001: Chỉ định UID
# -g 1001: Chỉ định GID (nodejs là tên group đã được tạo bởi addgroup -g 1001 -S nodejs)
RUN addgroup -g 1001 -S nodejs \
    && adduser -S appuser -u 1001 -G nodejs

WORKDIR /app 

# [2] Copy built files và production dependencies từ builder stage
# Sử dụng --chown=appuser:nodejs để thiết lập quyền sở hữu ngay lập tức cho các file copy
# Chỉ copy những thư mục cần thiết
COPY --from=builder --chown=appuser:nodejs /app/dist ./dist
COPY --from=builder --chown=appuser:nodejs /app/node_modules ./node_modules
# Cần package.json để khởi chạy ứng dụng (ví dụ: để kiểm tra main file hoặc scripts)
COPY --from=builder --chown=appuser:nodejs /app/package.json ./

# [3] Thiết lập User không phải root
USER appuser

# [4] Cấu hình Runtime
# Port ứng dụng
EXPOSE 4000

# Healthcheck cho service
# Thêm SHELL chỉ định /bin/sh -c để tránh vấn đề với wget trong Alpine
HEALTHCHECK --interval=20s --timeout=3s --start-period=10s --retries=3 \
    CMD wget -qO- http://localhost:4000/api/health || exit 1

# Lệnh khởi động ứng dụng
# Sử dụng exec form CMD ["node", "dist/server.mjs"] là tốt
CMD ["node", "dist/server.mjs"]