-- https://mumuki.io/nym/exercises/1788-programacion-funcional-dominar-el-mundo-con-nada-maximosegun

module Clase4 where

--mayorSegun f a b = max (f a) (f b)
mayorSegun :: Ord a => (a->a) -> a -> a -> a
-- Ord b => (a->b) -> a -> a -> b

mayorSegun funcion valorA valorB
  | funcion valorA > funcion valorB = valorA
  | otherwise = valorB

-- maximoSegun id [1,2,3,4,5]
-- maximoSegun negate [1,2,3,4,5]
-- maximoSegun length ["hola","paradigmas", "como","estas"]
