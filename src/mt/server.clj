(ns mt.server
  (:require [ring.adapter.jetty :as jetty]))

(def port 8080)

(defn handler [request]
  {:status 200
   :headers {"Content-Type" "text/html"}
   :body "<h1>test</h1>"})

(defn start []
  (println "starting server...")
  (jetty/run-jetty (var handler)
                   {:port port :join? false}))
