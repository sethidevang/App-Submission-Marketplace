CREATE TABLE IF NOT EXISTS products (
  id            text PRIMARY KEY,
  brand         text NOT NULL,
  name          text NOT NULL,
  category      text NOT NULL,
  icon          text NOT NULL,
  gradient_from text NOT NULL,
  gradient_to   text NOT NULL,
  price         integer NOT NULL,
  mrp           integer NOT NULL,
  max_tenure    integer NOT NULL,
  rating        numeric(2,1) NOT NULL,
  reviews       text NOT NULL,
  variants      jsonb NOT NULL DEFAULT '[]',
  highlights    text[] NOT NULL DEFAULT '{}',
  sort_order    integer NOT NULL DEFAULT 0
);
