(ns mt.js-bundle
  (:require [clojure.java.shell :refer [sh]]
            [compojure.core :refer [defroutes GET]]))

(defn compiled-bundle []
  (:out (sh "coffee" (str
         (System/getProperty "user.dir")
         "/modules/client_bundle.coffee"))))

(defroutes js-routes
  (GET "/bundle.js" []
      {:status 200
       :headers {"Content-Type" "application/javascript"}
       :body (compiled-bundle)}))
