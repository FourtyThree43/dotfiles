def func(x):
    y=2*x+1
    print("Result: ",y)
    
func(4)

class MyClass:
    def __init__(self, name):
        self.name = name

    def say_hello(self):
        print(f"Hello, {self.name}!")

my_obj = MyClass("World!")
my_obj.say_hello()

if 5 > 3:
    print("Five is greater than three.")
    
if 5<3:
    print("Five is less than three.")
    
if True and False:
    print("This will never execute.")
    
if True or False:
    print("This will always execute.")
