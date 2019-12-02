(ns day1.core
  (:gen-class)
  (:require [clojure.java.io :as io]
            [clojure.core :refer [slurp]]))

(defn mass->fuel [mass]
  (- (quot mass 3) 2))

(defn mass->total-fuel [mass]
  (reduce +
          (take-while
           pos-int?
           (drop 1 (iterate mass->fuel mass)))))

(defn read-input []
  (slurp (io/resource "input.txt")))

(defn -part1 []
  (apply +
         (->> (read-input)
              (split-lines)
              (map read-string)
              (map mass->fuel))))

(defn -part2 []
   (apply +
          (->> (read-input)
               (split-lines)
               (map read-string)
               (map mass->total-fuel))))

(-part1)
(-part2)
