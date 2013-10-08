(ns mt.core
  (:require [mt.server]))

(defn -main []
  (mt.server/start))
