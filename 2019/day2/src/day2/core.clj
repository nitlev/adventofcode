(ns day2.core
  (:gen-class)
  (:require [clojure.core :refer [slurp]]
            [clojure.java.io :refer [resource]]
            [clojure.string :as str]))

(def int->ops {1 + 2 *})

(defn run [program]
  (loop [i 0
         p program]
    (if (= 99 (get p i))
      p
      (let [op (int->ops (get p i))
            address (get p (+ i 3))
            x1 (get p (get p (+ i 1)))
            x2 (get p (get p (+ i 2)))]
        (recur (+ i 4)
               (update p address (fn [_] (op x1 x2))))))))

(defn restore [program value1 value2]
  (let [p (vec program)
        p1 (update p 1 (constantly value1))
        p2 (update p1 2 (constantly value2))]
    p2))

(defn step1
  "Star 1"
  []
  (let [text (slurp (resource "input.txt"))
        program (map read-string (str/split text #","))
        old-state (restore program 12 2)]
    (println old-state)
    (first (run old-state))))

(defn find-noun-and-verb [program value]
  (first
   (for [verb (range 100)
         noun (range 100)
         :let [output (run (restore program verb noun))]
         :when (= (first output) value)]
     [verb noun])))

(defn step2
  "Star 2"
  []
  (let [text (slurp (resource "input.txt"))
        program (map read-string (str/split text #","))]
    (find-noun-and-verb program 19690720)))

(step1)
(step2)
