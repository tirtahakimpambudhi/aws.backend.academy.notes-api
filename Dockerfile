FROM node:20-alpine AS builder

ARG username
ARG unique_id

WORKDIR /app

COPY package.json package-lock.json ./

RUN adduser \
        --disabled-password \
        --gecos "" \
        --home "/nonexistent" \
        --shell "/sbin/nologin" \
        --no-create-home \
        --uid "${unique_id}" \
        "${username}" \
    && npm i -g @vercel/ncc  \
    && npm ci

COPY . .

RUN npm run format && npm run lint \
    && ncc build src/index.js -o dist && \
    chown -R ${username}:${username} /app/dist

FROM gcr.io/distroless/nodejs22-debian12 AS production
ARG username

ENV HOST="0.0.0.0" \
    PORT=80

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

COPY --chown=${username}:${username} --from=builder /app/dist .
COPY --chown=${username}:${username} --from=builder /app/notes-api-test.*.json .

CMD ["index.js"]




