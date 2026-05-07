{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

-- import Data.GraphViz
import Data.GraphViz.Attributes (color, filled, shape, style, textLabel)
import Data.GraphViz.Attributes.Colors.X11 (X11Color (Blue, LightGray, White))
import Data.GraphViz.Attributes.Complete (Shape (MDiamond, MSquare))
import Data.GraphViz.Printing (renderDot, toDot)
import Data.GraphViz.Types.Generalised (DotGraph)
import Data.GraphViz.Types.Monadic (GraphID (Str), cluster, digraph, graphAttrs, node, nodeAttrs, (-->))
import Data.Text.Lazy.IO qualified as T

graph :: DotGraph String
graph =
  digraph (Str "G") $ do
    cluster (Str "cluster0") $ do
      graphAttrs [style filled, color LightGray]
      nodeAttrs [style filled, color White]
      "a0" --> "a1"
      "a1" --> "a2"
      "a2" --> "a3"
      graphAttrs [textLabel "process #1"]

    cluster (Str "cluster1") $ do
      nodeAttrs [style filled]
      "b0" --> "b1"
      "b1" --> "b2"
      "b2" --> "b3"
      graphAttrs [textLabel "process #2", color Blue]

    "start" --> "a0"
    "start" --> "b0"
    "a1" --> "b3"
    "b2" --> "a3"
    "a3" --> "end"
    "b3" --> "end"

    node "start" [shape MDiamond]
    node "end" [shape MSquare]

main :: IO ()
main = do
  -- dot -Tpng /tmp/graph.dot -o graph.png
  T.writeFile "/tmp/graph.dot" (renderDot (toDot graph))
  putStrLn "Tell me your name"
  name <- getLine
  putStrLn ("Hello " ++ name ++ ", nice to meet you.")
