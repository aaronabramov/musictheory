(ns mt.server
  (:require [ring.adapter.jetty :as jetty]
            [compojure.core :refer [defroutes routes GET]]
            [ring.middleware.reload :as reload]
            [mt.js-bundle :refer [js-routes]]))

(def port 8080)

(def home-template (slurp "./src/mt/templates/home.html"))

(defn handler [request]
  {:status 200
   :headers {"Content-Type" "text/html"}
   :body home-template})


(defroutes app-routes
  (-> (routes
        js-routes
        (GET "/" request (handler request)))
      (reload/wrap-reload)))

(defn start []
  (println "starting server...")
  (jetty/run-jetty app-routes
                   {:port port :join? false}))
