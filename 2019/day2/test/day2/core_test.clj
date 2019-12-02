(ns day2.core-test
  (:require [clojure.test :refer :all]
            [day2.core :refer :all]))

(deftest input-tests
  (testing "Output should match"
    (is (= (run [1 0 0 0 99]) [2 0 0 0 99]))
    (is (= (run [2 3 0 3 99]) [2 3 0 6 99]))
    (is (= (run [2 4 4 5 99 0]) [2 4 4 5 99 9801]))
    (is (= (run [1 1 1 4 99 5 6 0 99]) [30 1 1 4 2 5 6 0 99]))))


(deftest int->ops-tests
  (testing "int->ops 1 should be adding"
    (is (= 1 ((int->ops 1) 0 1)))
    (is (= 5 ((int->ops 1) 2 3))))
  (testing "int->ops 2 should be multiplying"
    (is (= 0 ((int->ops 2) 0 1)))
    (is (= 6 ((int->ops 2) 2 3)))))
