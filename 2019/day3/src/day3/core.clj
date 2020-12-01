(ns day3.core
  (:gen-class)
  (:require [clojure.core :refer [slurp]]
            [clojure.java.io :refer [resource]]
            [clojure.string :as str]
            [clojure.set :as set]))

(defn parse-direction [s]
  (let [[direction & distance] s]
    [direction (read-string (apply str distance))]))

(defn get-path [starting-point direction distance]
  (let [[start-x start-y] starting-point]
    (case direction
      \R (map (fn [d] [(+ start-x d) start-y])
              (range 1 (inc distance)))
      \L (map (fn [d] [(- start-x d) start-y])
              (range 1 (inc distance)))
      \U (map (fn [d] [start-x (+ start-y d)])
              (range 1 (inc distance)))
      \D (map (fn [d] [start-x (- start-y d)])
              (range 1 (inc distance))))))

(defn get-full-path [starting-point path-codes]
  (reduce
   (fn [[current-point points] path-code]
     (let [[direction distance] (parse-direction path-code)
           path (get-path current-point direction distance)
           new-current-point (last path)
           new-points (set/union points (set path))]
       [new-current-point new-points]))
   [starting-point #{}]
   path-codes))

(defn manh-distance [[x y]]
  (+ (Math/abs x) (Math/abs y)))

(defn step1
  "Star 1"
  []
  (let [text (slurp (resource "input.txt"))
        wires (map #(str/split % #",") (str/split-lines text))
        [_ points1] (get-full-path [0 0] (first wires))
        [_ points2] (get-full-path [0 0] (second wires))
        intersections (set/intersection points1 points2)]
    (println intersections)
    (first (sort-by manh-distance intersections))))

(step1)

(defn get-path-with-steps [starting-point first-step direction distance]
  (let [[start-x start-y] starting-point]
    (case direction
      \R (map (fn [d] [[(+ start-x d) start-y] (+ first-step d)])
              (range 1 (inc distance)))
      \L (map (fn [d] [(- start-x d) start-y])
              (range 1 (inc distance)))
      \U (map (fn [d] [start-x (+ start-y d)])
              (range 1 (inc distance)))
      \D (map (fn [d] [start-x (- start-y d)])
              (range 1 (inc distance))))))

(defn get-full-path [starting-point path-codes]
  (reduce
   (fn [[current-point points] path-code]
     (let [[direction distance] (parse-direction path-code)
           path (get-path current-point direction distance)
           new-current-point (last path)
           new-points (set/union points (set path))]
       [new-current-point new-points]))
   [starting-point #{}]
   path-codes))
