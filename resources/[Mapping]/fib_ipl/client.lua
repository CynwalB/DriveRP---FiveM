local marshal 

RegisterCommand("ms", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if marshal then
        marshal = false
        RefreshInterior(interiorHash)
        DisableInteriorProp(interiorHash, "qnx_ms_logo_ms")
        DisableInteriorProp(interiorHash, "qnx_mw_logo_ms")
    else
        marshal = true
        RefreshInterior(interiorHash)
        EnableInteriorProp(interiorHash, "qnx_ms_logo_ms2")
        EnableInteriorProp(interiorHash, "qnx_mw_logo_ms2")

    end
end, false)

local tun = GetInteriorAtCoordsWithType(23.16989000,-921.68690000,75.44691000,"qnx_ms_logo_ms") 
EnableInteriorProp(tun, "qnx_ms_logo_ms2") --
EnableInteriorProp(tun, "qnx_ms_logo_ms2") --
EnableInteriorProp(tun, "set2") --
EnableInteriorProp(tun, "set3") --
EnableInteriorProp(tun, "set4") --
EnableInteriorProp(tun, "set5") --
EnableInteriorProp(tun, "set6") --
EnableInteriorProp(tun, "set7") --
EnableInteriorProp(tun, "set8") --
EnableInteriorProp(tun, "set9") --
RefreshInterior(tun)


local nrgqerbwE = {

  ["qnx_marshall"] = {

    dfbrtrty = "qnx_ms_milo_",

    srnsrtnrter = "qnx_ms",

    mtneetywennf = true,

    jnmhtyuu = false,

    ghny = vector3(23.16989000,-921.68690000,75.44691000),

    jkiuy = {

      {

        uiou = 0,

        yut = 8192,

        erwq = {

          vector3(-8.6551,-17.7904,-46.5444),

          vector3(-8.6551,-17.7904,-43.2743),

          vector3(-12.512,-13.9466,-43.2743),

          vector3(-12.512,-13.9466,-46.5444),

        },

      },

      {

        uiou = 1,

        yut = 8192,

        erwq = {

          vec(-8.72455,-7.04046,-44.1449),

          vec(-8.72455,-7.04046,-46.5444),

          vec(-10.6936,-9.00953,-46.5444),

          vec(-10.6936,-9.00953,-44.1449),

        },

      },

      {

        uiou = 2,

        yut = 8192,

        erwq = {

          vec(-3.73837,-15.9648,-46.5444),

          vec(-3.73837,-15.9648,-44.1449),

          vec(-1.76931,-13.9957,-44.1449),

          vec(-1.76931,-13.9957,-46.5444),

        },

      },

      {

        uiou = 3,

        yut = 8192,

        erwq = {

          vec(-2.78762,-9.99738,-45.5845),

          vec(-2.78762,-9.99738,-44.1449),

          vec(-4.75669,-8.02831,-44.1449),

          vec(-4.75669,-8.02831,-45.5845),

        },

      },

      {

        uiou = 4,

        yut = 8192,

        erwq = {

          vec(-8.90559,-5.68710,-46.5444),

          vec(-8.90559,-5.68710,-44.1449),

          vec(-10.8747,-3.71803,-44.1449),

          vec(-10.8747,-3.71803,-46.5444),

        },

      },

      {

        uiou = 5,

        yut = 8192,

        erwq = {

          vec(-12.6721,-3.99473,-46.5444),

          vec(-12.6721,-3.99473,-44.2183),

          vec(-13.8017,-5.08066,-44.2183),

          vec(-13.8017,-5.08066,-46.5444),

        },

      },

      {

        uiou = 6,

        yut = 8192,

        erwq = {

          vec(-9.35903,-1.44606,-46.5668),

          vec(-9.35903,-1.44606,-44.1431),

          vec(-10.3985,-2.48556,-44.1431),

          vec(-10.3985,-2.48556,-46.5668),

        },

      },

      {

        uiou = 7,

        yut = 8192,

        erwq = {

          vec(-5.64643,2.25714,-46.5668),

          vec(-5.64643,2.25714,-44.1431),

          vec(-6.70790,1.18909,-44.1431),

          vec(-6.70790,1.18909,-46.5668),

        },

      },

      {

        uiou = 8,

        yut = 8192,

        erwq = {

          vec(-1.24031,6.68231,-46.5668),

          vec(-1.24031,6.68231,-44.1431),

          vec(-2.30178,5.61425,-44.1431),

          vec(-2.30178,5.61425,-46.5668),

        },

      },

      {

        uiou = 9,

        yut = 64,

        erwq = {

          vec(-6.84517,6.62527,-44.1411),

          vec(-6.83669,6.61679,-45.5562),

          vec(-4.86111,4.64121,-45.5586),

          vec(-4.86195,4.64206,-44.1622),

        },

      },

      {

        uiou = 10,

        yut = 8192,

        erwq = {

          vec(1.546260,4.78089,-46.5668),

          vec(1.546260,4.78089,-44.1431),

          vec(-0.42899,6.74213,-44.1431),

          vec(-0.42899,6.74213,-46.5668),

        },

      },

      {

        uiou = 11,

        yut = 8192,

        erwq = {

          vec(9.899221,-3.51743,-46.56680),

          vec(9.899221,-3.51743,-43.59420),

          vec(4.826190,1.546660,-43.59420),

          vec(4.826190,1.546660,-46.56680),

        },

      },

      {

        uiou = 12,

        yut = 8192,

        erwq = {

          vec(4.43996,-13.0109,-46.5444),

          vec(4.43996,-13.0109,-44.1449),

          vec(6.40903,-11.0419,-44.1449),

          vec(6.40903,-11.0419,-46.5444),

        },

      },

      {

        uiou = 13,

        yut = 8192,

        erwq = {

          vec(0.9568529,14.80610,-46.5444),

          vec(0.9568529,14.80610,-44.1207),

          vec(-1.004390,12.83080,-44.1207),

          vec(-1.004390,12.83080,-46.5444),

        },

      },

      {

        uiou = 14,

        yut = 8192,

        erwq = {

          vec(4.40126,12.4694,-46.5444),

          vec(4.40126,12.4694,-44.1207),

          vec(2.42600,14.4307,-44.1207),

          vec(2.42600,14.4307,-46.5444),

        },

      },

      {

        uiou = 15,

        yut = 8192,

        erwq = {

          vector3(1.121530,21.1908,-43.4900),

          vector3(1.121530,21.1908,-46.5444),

          vector3(-1.58778,21.1893,-46.5444),

          vector3(-1.58778,21.1893,-43.4900),

        },

      },

      {

        uiou = 16,

        yut = 8192,

        erwq = {

          vec(13.2066,3.65719,-44.1207),

          vec(13.2066,3.65719,-46.5444),

          vec(11.2313,5.61843,-46.5444),

          vec(11.2313,5.61843,-44.1207),

        },

      },

      {

        uiou = 17,

        yut = 8192,

        erwq = {

          vec(10.0995,9.50142,-46.5444),

          vec(10.0995,9.50142,-44.1207),

          vec(12.0608,11.4767,-44.1207),

          vec(12.0608,11.4767,-46.5444),

        },

      },

      {

        uiou = 18,

        yut = 8192,

        erwq = {

          vec(-10.3985,-2.48556,-42.5499),

          vec(-10.3985,-2.48556,-40.1262),

          vec(-9.35903,-1.44606,-40.1262),

          vec(-9.35903,-1.44606,-42.5499),

        },

      },

      {

        uiou = 19,

        yut = 8192,

        erwq = {

          vec(-10.9356,-3.77997,-42.5499),

          vec(-10.9356,-3.77997,-40.1262),

          vec(-8.96253,-5.74185,-40.1262),

          vec(-8.96253,-5.74185,-42.5499),

        },

      },

      {

        uiou = 20,

        yut = 8192,

        erwq = {

          vec(-12.6721,-3.99473,-42.5499),

          vec(-12.6721,-3.99473,-40.2238),

          vec(-13.8017,-5.08066,-40.2238),

          vec(-13.8017,-5.08066,-42.5499),

        },

      },

      {

        uiou = 21,

        yut = 8192,

        erwq = {

          vec(-5.72175,2.13791,-42.5555),

          vec(-5.72175,2.13791,-40.1318),

          vec(-6.77729,1.08099,-40.1318),

          vec(-6.77729,1.08099,-42.5555),

        },

      },

      {

        uiou = 22,

        yut = 8192,

        erwq = {

          vec(-2.72430,1.59530,-42.5555),

          vec(-2.72430,1.59530,-40.1318),

          vec(-3.78122,2.65084,-40.1318),

          vec(-3.78122,2.65084,-42.5555),

        },

      },

      {

        uiou = 23,

        yut = 8192,

        erwq = {

          vec(-8.52378,-6.00893,-42.5555),

          vec(-8.52378,-6.00893,-39.3784),

          vec(-5.16379,-2.67418,-39.3784),

          vec(-5.16379,-2.67418,-42.5555),

        },

      },

      {

        uiou = 24,

        yut = 8192,

        erwq = {

          vec(-6.72987,-18.5505,-42.5555),

          vec(-6.72987,-18.5505,-39.3784),

          vec(-2.42650,-14.2409,-39.3784),

          vec(-2.42650,-14.2409,-42.5555),

        },

      },

      {

        uiou = 25,

        yut = 8192,

        erwq = {

          vec(-1.26223,-13.0891,-42.5555),

          vec(-1.26223,-13.0891,-39.3784),

          vec(3.017930,-8.80021,-39.3784),

          vec(3.017930,-8.80021,-42.5555),

        },

      },

      {

        uiou = 26,

        yut = 8192,

        erwq = {

          vec(2.897180,-7.43183,-42.5555),

          vec(2.897180,-7.43183,-39.3784),

          vec(-1.10003,-3.43464,-39.3784),

          vec(-1.10003,-3.43464,-42.5555),

        },

      },

      {

        uiou = 27,

        yut = 4,

        erwq = {

          vec(-4.90439,4.63596,-44.1958),

          vec(-4.90414,4.63621,-45.5256),

          vec(-6.84725,6.57886,-45.5256),

          vec(-6.84706,6.57904,-44.1958),

        },

      },

      {

        uiou = 28,

        yut = 4,

        erwq = {

          vec(4.17329,5.17975,-41.2320),

          vec(4.17329,5.17975,-39.6256),

          vec(5.37574,3.97730,-39.6256),

          vec(5.37574,3.97730,-41.2320),

        },

      },

      {

        uiou = 29,

        yut = 4,

        erwq = {

          vec(-1.61619,10.97910,-41.2320),

          vec(-1.61619,10.97910,-39.6256),

          vec(-0.39082,9.753730,-39.6256),

          vec(-0.39082,9.753730,-41.2320),

        },

      },

    }

  }

}


Citizen.CreateThread(function()

  while true do

    Citizen.Wait(2000)

      local ukioo = Citizen.InvokeNative(0xD80958FC74E988A6)

      local rtyyt = GetEntityCoords(ukioo)

      for _,asde in pairs(nrgqerbwE) do

        local yyyrb = #(rtyyt - asde.ghny)

        if yyyrb < 150 then

          if asde.mtneetywennf and not asde.jnmhtyuu then

            Citizen.InvokeNative(0x41B4893843BBDB74,asde.dfbrtrty)

            local ujymm = Citizen.InvokeNative(0x05B7A89BD78797FC,asde.ghny,asde.srnsrtnrter)

            while not IsInteriorReady(ujymm) do

              Wait(0)

            end

            for _,tyur in pairs(asde.jkiuy) do

              Citizen.InvokeNative(0x88B2355E,ujymm,tyur.uiou,tyur.yut)

              for i,ghny in pairs(tyur.erwq) do

                Citizen.InvokeNative(0x87F43553,ujymm,tyur.uiou,i-1,ghny)

              end

            end

            if not asde.jnmhtyuu then

              asde.jnmhtyuu = true

              Citizen.InvokeNative(0x41F37C3427C75AE0,ujymm)

            end

          end

        else

          asde.jnmhtyuu = false

          Citizen.InvokeNative(0xEE6C5AD3ECE0A82D,asde.dfbrtrty)

        end

      Wait(0)

      end

  end

end)