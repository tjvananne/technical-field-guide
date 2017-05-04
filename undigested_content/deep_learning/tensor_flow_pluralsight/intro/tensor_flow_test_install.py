# python3.5 (TensorFlow only supports Python3.5.x on Windows)
import tensorflow as tf 


# session is the context in which you run your code
sess = tf.Session()


# verify we can print a string
hello = tf.constant("Hello Pluralsight from Tensorflow")
print(sess.run(hello))


# perform some simple math
a = tf.constant(20)
b = tf.constant(22)
print('a + b = {0}'.format(sess.run(a + b)))


