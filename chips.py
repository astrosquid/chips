class Ground():
    def __init__(self):
        self.output = 0

class Vcc():
    def __init__(self):
        self.output = 1

class LogicChip():
    """Just something for other chips to take after."""
    def __init__(self, inputs):
        x = []
        for i in inputs:
            x.append(i.output)
        self.inputs = x
        self.output = None

    def new_inputs(self, inputs):
        x = []
        for i in inputs:
            x.append(i.output)
        self.inputs = x

    def do(self):
        pass

    def get_output(self):
        self.do()
        return self.output

class Not(LogicChip):
    def __init_(self, inputs):
        super().__init__(inputs)
        
    def do(self):
        if input[0] == 0:
            self.output = 1
        else:
            self.output = 0

class And(LogicChip):
    def __init__(self, inputs):
        super().__init__(inputs)
        self.input_values = set()
        for i in inputs:
            self.input_values.add(i.output)

    def do(self):
        if len(set(self.inputs)) == 1:
            self.output = 1
        else: 
            self.output = 0

class Or(LogicChip):
    def __init__(self, inputs):
        super().__init__(inputs)
        
    def do(self):
        for i in self.inputs:
            if i == 1:
                self.output = 1
            
        if self.output != 1:
            self.output = 0

class Xor(LogicChip):
    def __init__(self, inputs):
        super().__init__(inputs)

    def do(self):
        flag = False
        for i in self.inputs:
            if i == 1 and flag == True:
                self.output = 0
                flag = False
                break
            elif i == 1 and flag == False:
                flag = True

        if flag == True:
            self.output = 1

class Nand(LogicChip):
    def __init__(self, inputs):
        super().__init__(inputs)

    def do(self):
        if len(set(self.inputs)) == 1:
            if self.inputs[0] == 1:
                self.output = 0
            else:
                self.output = 1
        else:
            self.output = 1

if __name__ == "__main__":
    vcc = Vcc()
    grr = Ground()
    orr = Or([grr, grr])
    andd = And([vcc, vcc, grr])
    orr.do()
    andd.do()
    nand = Nand([orr, andd])
    nand.do()
    print(nand.output)
