require_relative './chips'

describe Logic do 
    l1 = Logic.new([true])
    l2 = Logic.new([false, true, false, true])

    it 'has an output equal to its input' do 
        expect(l1.eval).to eq([true])
        expect(l2.eval).to eq([false, true, false, true])
    end 
    
    it 'produces a binary string indicative of its output' do 
        expect(l1.to_bin_str).to eq('1')
        expect(l2.to_bin_str).to eq('1010')
    end 
end

describe Vcc do 
    vcc = Vcc.new 

    it 'always outputs true' do 
        expect(vcc.eval).to eq(true)
    end 
end 

describe Ground do 
    gnd = Ground.new 

    it 'always outputs false' do 
        expect(gnd.eval).to eq(false)
    end 
end 

describe And do 
    a1 = And.new([true, true])
    a2 = And.new([true, false])
    a3 = And.new([false, true])
    a4 = And.new([false, false])

    it 'only outputs TRUE when all inputs are TRUE' do 
        expect(a1.eval).to eq(true)
        expect(a2.eval).to eq(false)
        expect(a3.eval).to eq(false)
        expect(a4.eval).to eq(false)
    end 

    it 'can take more than two inputs' do 
        a5 = And.new([true, true, true, true, true, true, true, false])
        expect(a5.eval).to eq(false)
        a5.input = [true, true, true, true, true, true, true, true]
        expect(a5.eval).to eq(true)
    end 
end 

describe Or do 
    o1 = Or.new([true, true])
    o2 = Or.new([true, false])
    o3 = Or.new([false, true])
    o4 = Or.new([false, false])

    it 'outputs TRUE when any inputs are TRUE' do 
        expect(o1.eval).to eq(true)
        expect(o2.eval).to eq(true)
        expect(o3.eval).to eq(true)
        expect(o4.eval).to eq(false)
    end 

    it 'correctly evaluates more than two inputs' do 
        o5 = Or.new([true, true, true, true, true, true, true, false])
        expect(o5.eval).to eq(true)
        o5.input = [true, true, true, true, true, true, true, true]
        expect(o5.eval).to eq(true)
        o5.input = [false, false, false, false, false, false, false, false]
        expect(o5.eval).to eq(false)
    end 
end 

describe Xor do 
    o1 = Xor.new([true, true])
    o2 = Xor.new([true, false])
    o3 = Xor.new([false, true])
    o4 = Xor.new([false, false])

    it 'outputs TRUE only when one input is TRUE' do 
        expect(o1.eval).to eq(false)
        expect(o2.eval).to eq(true)
        expect(o3.eval).to eq(true)
        expect(o4.eval).to eq(false)
    end 

    it 'correctly evaluates more than two inputs' do 
        o5 = Xor.new([true, true, true, true, true, true, true, false])
        expect(o5.eval).to eq(false)
        o5.input = [true, true, true, true, true, true, true, true]
        expect(o5.eval).to eq(false)
        o5.input = [false, false, false, false, false, false, false, true]
        expect(o5.eval).to eq(true)
    end 
end 

describe Nand do 
    a1 = Nand.new([true, true])
    a2 = Nand.new([true, false])
    a3 = Nand.new([false, true])
    a4 = Nand.new([false, false])

    it 'only outputs TRUE when all inputs are TRUE' do 
        expect(a1.eval).to eq(false)
        expect(a2.eval).to eq(true)
        expect(a3.eval).to eq(true)
        expect(a4.eval).to eq(true)
    end 

    it 'can take more than two inputs' do 
        a5 = Nand.new([true, true, true, true, true, true, true, false])
        expect(a5.eval).to eq(true)
        a5.input = [true, true, true, true, true, true, true, true]
        expect(a5.eval).to eq(false)
    end 
end 

describe Switch do 
    vcc = Vcc.new 
    s1 = Switch.new([vcc])

    it 'outputs the value of the input before being flipped' do 
        expect(s1.eval).to eq(true)
    end 

    it 'outputs the opposite value after being flipped' do 
        s1.flip
        expect(s1.eval).to eq(false)
    end

    it 'outputs the original value when flipped a second time' do 
        s1.flip 
        expect(s1.eval).to eq(true)
    end
end 

describe TwoInputHalfAdder do 
    vcc = Vcc.new 
    gnd = Ground.new 

    tiha = TwoInputHalfAdder.new(vcc, gnd)

    it 'has two inputs' do 
        expect(tiha.input.length).to eq(2)
    end 

    context 'generates correct outputs' do 
        it 'generates 01 when only one input is 1' do 
            expect(tiha.eval).to eq([true, false])
            expect(tiha.to_bin_str).to eq('01')
            tiha.input = [gnd, vcc]
            expect(tiha.eval).to eq([true, false])
            expect(tiha.to_bin_str).to eq('01')
        end 

        it 'generates 10 when both inputs are 1' do 
            tiha.input = [vcc, vcc]
            expect(tiha.eval).to eq([false, true])
            expect(tiha.to_bin_str).to eq('10')
        end
    end 
end 

describe TwoInputFullAdder do 
    gnd = Ground.new 
    s0 = Switch.new([gnd])
    s1 = Switch.new([gnd])
    s2 = Switch.new([gnd])

    tifa = TwoInputFullAdder.new(s0, s1, s2)

    it 'has three inputs' do 
        expect(tifa.input.length).to eq(3)
    end 

    context 'generates correct outputs' do 
        it 'produces 00 when the input is 000' do 
            expect(tifa.eval).to eq([false, false])
        end 

        it 'produces 11 when the input is 111' do 
            s0.flip
            s1.flip
            s2.flip
            expect(tifa.eval).to eq([true, true])
            s0.flip
            s1.flip
            s2.flip
        end

        context 'produces 01 when' do 
            it 'the input is 001' do 
                s2.flip 
                expect(tifa.eval).to eq([true, false])
                s2.flip
            end 
    
            it 'the input is 010' do 
                s1.flip 
                expect(tifa.eval).to eq([true, false])
                s1.flip
            end
    
            it 'the input is 100' do 
                s0.flip 
                expect(tifa.eval).to eq([true, false])
                s0.flip
            end
        end

        context 'produces 10 when' do 
            it 'the input is 011' do 
                s1.flip
                s2.flip 
                expect(tifa.eval).to eq([false, true])
                s1.flip
                s2.flip 
            end 
    
            it 'the input is 101' do 
                s0.flip
                s2.flip 
                expect(tifa.eval).to eq([false, true])
                s0.flip
                s2.flip 
            end
    
            it 'the input is 110' do 
                s0.flip
                s1.flip 
                expect(tifa.eval).to eq([false, true])
                s0.flip
                s1.flip 
            end
        end
    end 
end 