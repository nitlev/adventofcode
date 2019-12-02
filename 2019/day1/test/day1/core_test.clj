(ns day1.core-test
  (:require [clojure.test :refer :all]
            [day1.core :refer :all]))

(deftest input-tests
  (testing "input and input matches"
    (is (= 2 (mass->fuel 12)))
    (is (= 2 (mass->fuel 14)))
    (is (= 654 (mass->fuel 1969)))
    (is (= 33583 (mass->fuel 100756)))))
