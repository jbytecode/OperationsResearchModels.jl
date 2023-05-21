@testset "CPM" begin

    @testset "earliest finishing times of activities" begin
        A = CpmActivity("A", 3)
        B = CpmActivity("B", 2)
        C = CpmActivity("C", 4, [A, B])
        D = CpmActivity("D", 5, [A, B])
        E = CpmActivity("E", 7, [C, D])
        F = CpmActivity("F", 10, [A, B, C, D, E])

        activities = CpmActivity[A, B, C, D, E, F]

        @test earliestfinishtime(A) == 3
        @test earliestfinishtime(B) == 2
        @test earliestfinishtime(C) == 7
        @test earliestfinishtime(D) == 8
        @test earliestfinishtime(E) == 15
        @test earliestfinishtime(F) == 25

        @test longestactivity(activities) == F
    end

    @testset "cpm with 6 activities" begin 
        A = CpmActivity("A", 3)
        B = CpmActivity("B", 2)
        C = CpmActivity("C", 4, [A, B])
        D = CpmActivity("D", 5, [A, B])
        E = CpmActivity("E", 7, [C, D])
        F = CpmActivity("F", 10, [A, B, C, D, E])

        activities = CpmActivity[A, B, C, D, E, F]

        result = cpm(activities)

        @test result isa CpmResult 

        @test result.pathstr == ["A", "D", "E", "F"]

        @test result.path == [A, D, E, F]
    end

    @testset "cpm with 10 activities" begin 
        A = CpmActivity("A", 2);
        B = CpmActivity("B", 3);
        C = CpmActivity("C", 2, [A]);
        D = CpmActivity("D", 3, [B]);
        E = CpmActivity("E", 2, [B]);
        F = CpmActivity("F", 3, [C, D]);
        G = CpmActivity("G", 7, [E]);
        H = CpmActivity("H", 5, [E]);
        I = CpmActivity("I", 6, [G, F]);
        J = CpmActivity("J", 2, [C, D]);

        activities = [A, B, C, D, E, F, G, H, I, J]
        result = cpm(activities)

        @test result.pathstr == ["B", "E", "G", "I"]
        @test result.path == [B, E, G, I]
    end 
end