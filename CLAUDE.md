# Kairos — Demo Build

## Contexto del proyecto

Kairos es una plataforma SaaS de influencer marketing impulsada por IA.
Estamos construyendo un DEMO NAVEGABLE, no un producto productivo todavia.

Objetivo del demo: una URL publica que muestre el flujo:
1. Brand setup con scraping IA del sitio web del cliente
2. Campaign builder de 4 pasos
3. Match results con scoring real (sobre data sintetica curada)
4. Brief generator con Claude API real
5. Dashboard con datos sinteticos pero creibles

El demo es para: pitch a inversionistas y captura de primeros pilotos pagos.

## Stack

- Next.js 16 con App Router + TypeScript ESTRICTO (jamas usar any)
- Supabase (auth + Postgres + pgvector + storage)
- shadcn/ui + Tailwind CSS para todo el UI
- Anthropic API (claude-sonnet-4-7) para extraccion y briefs
- OpenAI text-embedding-3-small para embeddings vectoriales
- lucide-react para iconos
- zod para validacion de schemas
- react-hook-form para formularios
- sonner para toasts

## Convenciones de codigo

- Server Components por default. "use client" solo si hay state o eventos.
- Queries de DB van en lib/data/*.ts, todas tipadas con zod.
- API routes en app/api/* validan input con zod siempre.
- Server Actions para mutaciones, no API routes.
- Errores: nunca silenciar. throw con mensaje util.
- RLS activo en todas las tablas con datos de usuario.

## Identidad visual

- Tema oscuro: #0a0a0a fondo, #f5f1e8 texto principal
- Acento principal: #e8ff34 (lima electrico)
- Tipografia display: Fraunces (serif italic)
- Tipografia sans: Inter Tight
- Tipografia mono: JetBrains Mono
- Densidad estilo Linear/Stripe: informacion sin ruido visual
- NO usar gradientes morados, NO usar Inter regular como tipografia principal

## Lo que NO hacer

- NO instalar dependencias sin confirmar conmigo primero
- NO crear Docker / docker-compose
- NO microservicios, todo en el monorepo Next.js
- NO usar any en TypeScript
- NO tocar archivos fuera de los que te diga
- NO refactorizar codigo que ya funciona a menos que te lo pida
- NO usar localStorage para datos sensibles

## Workflow conmigo (Jeronimo)

- ANTES de escribir codigo, lista los archivos que vas a crear o modificar
- Despues de cada feature completada, hacer commit con mensaje descriptivo
- Si te encuentras con una decision de arquitectura, preguntame antes
- Si una libreria no existe en package.json, NO la importes, preguntame si la instalo

## Identidad de marca demo

- Marca demo principal: Voltta Coffee (DTC ficticia de cold brew, Bogota)
- Categoria: F&B / Cafe especialidad
- Ticket promedio: 48000 COP
- Audiencia: 22-38, urbana, profesional
