require 'pry'

# A chip has an eval() function that 
# calls eval() on that chip's inputs.

# RULES
# STAY LITTLE-ENDIAN
# UNTIL BINARY OUTPUT

class Logic 
    attr_accessor :input 
    attr_reader :output 
    
    def initialize(input_array)
        @input = input_array
    end 
    
    def eval
        @output = @input
    end 

    def to_bin_str
        @output.map do |digit|
            if digit == true 
                '1'
            else 
                '0'
            end 
        end.join('').reverse
    end

    def eval_all
        values = @input.map do |b|
            if b.is_a? Logic 
                b.eval 
            else 
                b 
            end 
        end 
    end 
end 

class Vcc < Logic 
    def initialize
        @input = true 
    end 
end 

class Ground < Logic 
    def initialize 
        @input = false 
    end 
end 

class Inverter < Logic 
    def eval 
        @output = !(@input.eval)
    end 
end 

class And < Logic
    def eval 
        @output = self.eval_all.all? do |b|
            b == true 
        end 
    end 
end 

class Or < Logic
    def eval 
        @output = self.eval_all.any? do |b|
            b == true 
        end 
    end 
end 

class Xor < Logic
    def eval 
        @output = self.eval_all.one? do |b|
            b == true 
        end 
    end 
end 

class Nand < Logic
    def eval  
        and_a = And.new(@input)
        @output = !(and_a.eval)
    end 
end 

class Switch < Logic 
    def initialize(input)
        @input = super(input)
        @flipped = false
    end 
    
    def eval 
        @output = @input.first.eval 
        if @flipped 
            @output = !(@output)
        end 
        @output
    end 
    
    def flip 
        @flipped = !@flipped 
    end 
end 

class TwoInputHalfAdder < Logic 
    # Half-adder, no carry-in.
    def initialize(i0, i1)
        super([i0, i1])
    end 

    def eval 
        xor_0 = Xor.new([@input[0], @input[1]]).eval
        and_0 = And.new([@input[0], @input[1]]).eval
        @output = [xor_0, and_0] # [sum, carry_out]
    end 
end 

class TwoInputFullAdder < Logic 
    def initialize(c_in, i0, i1)
        super([c_in, i0, i1])
    end

    def eval 
        h0 = TwoInputHalfAdder.new(@input[1], @input[2]).eval 
        h1 = TwoInputHalfAdder.new(@input[0], h0[0]).eval
        or0 = Or.new([h0[1], h1[1]]).eval
        @output = [h1[0], or0] # [sum, carry_out]
    end 
end 

class TwoInputMultiplexer < Logic 
    def initialize(s0, i0, i1)
        super([s0, i0, i1])
    end
    
    def eval 
        s0 = @input[0]
        i0 = @input[1]
        i1 = @input[2]
        and_0 = And.new([Inverter.new([s0]), i0]).eval
        and_1 = And.new([s0, i1]).eval
        @output = Or.new([and_1, and_0]).eval
    end 
end 

class FourInputMultiplexer < Logic
    def initialize(s0, s1, i0, i1, i2, i3)
        super([s0, s1, i0, i1, i2, i3])
    end 

    def eval 
        s0 = @input[0]
        s1 = @input[1]
        i0 = @input[2]
        i1 = @input[3]
        i2 = @input[4]
        i3 = @input[5]

        and0 = And.new([i0, Inverter.new(s0), Inverter.new(s1)])
        and1 = And.new([i1, Inverter.new(s0), s1])
        and2 = And.new([i2, s0, Inverter.new(s1)])
        and3 = And.new([i3, s0, s1])

        @output = Or.new([and0, and1, and2, and3]).eval
    end 
end 

# vcc = Vcc.new 
# gnd = Ground.new 

# s0 = Switch.new([vcc])
# s1 = Switch.new([vcc])
# s2 = Switch.new([gnd])

# h0 = TwoInputHalfAdder.new(vcc, gnd)

# tifa = TwoInputFullAdder.new(s0, s1, s2)

# mux_2 = TwoInputMultiplexer.new(s0, vcc, gnd)
# mux_4 = FourInputMultiplexer.new(s0, s1, gnd, vcc, gnd, vcc)

# binding.pry