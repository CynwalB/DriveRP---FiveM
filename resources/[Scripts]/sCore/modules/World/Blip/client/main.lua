local AeroEvent = TriggerServerEvent
-- Kaka ↓
local Blips = {
    {
        pos = vector3(24.03, -1345.63, 29.5-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(1164.94, -323.76, 68.2-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(372.85, 328.10, 102.56-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(1134.24, -983.14, 45.41-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(-1221.40, -908.02, 11.32-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(-47.39, -1758.72, 28.42-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(1728.62, 6416.81, 34.03-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    -- {
    --     pos = vector3(1696.92, 4923.68, 42.08-0.98),
    --     blip = {
    --         label = "Supérette", 
    --         ID = 59, 
    --         Color = 69
    --     },
    -- },
    {
        pos = vector3(161.92, 6642.96, 31.72-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(-2966.37, 391.57, 15.04-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(-1486.64,-377.6, 40.16-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(-1820.52, 794.6,138.08-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(1165.48, 2710.8, 38.16-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(2676.52, 3280.24, 55.24-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(549.32, 2669.44, 42.16-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(-3040.76, 584.0, 7.92-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(-3244.2, 1000.2, 12.84-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(2555.36, 380.84, 108.64-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(1392.28, 3606.2, 35.0-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(241.33, -897.79, 29.62-0.98),
        blip = {
            label = "Supérette", 
            ID = 59, 
            Color = 69
        },
    },
    {
        pos = vector3(-177.74508056641, 219.1667480469, 89.91048555374146),
        blip = {
            label = "Entrepôt", 
            ID = 478, 
            Color = 40
        },
    },
    {
        pos = vector3(1240.4508056641, -3168.1667480469, 7.1048555374146),
        blip = {
            label = "Entrepôt", 
            ID = 478, 
            Color = 40
        },
    },
    {
        pos = vector3(-354.224508056641, 6066.1667480469, 31.48555374146),
        blip = {
            label = "Entrepôt", 
            ID = 478, 
            Color = 40
        },
    },
    {
        pos = vector3(-965.04508056641,-2067.31667480469,9.41048555374146),
        blip = {
            label = "Entrepôt", 
            ID = 478, 
            Color = 40
        },
    },
    {
        pos = vector3(2513.23666992188,4108.8640625,38.630710601807),
        blip = {
            label = "Entrepôt", 
            ID = 478, 
            Color = 40
        },
    },
    {
        pos = vector3(-1130.14508056641,2700.2667480469,18.81048555374146),
        blip = {
            label = "Entrepôt", 
            ID = 478, 
            Color = 40
        },
    },
    {
        pos = vector3(793.4308056641,-81.3667480469,80.555374146),
        blip = {
            label = "Entrepôt", 
            ID = 478, 
            Color = 40
        },
    },
    {
        pos = vector3(1216.14508056641,1846.667480469,78.91048555374146),
        blip = {
            label = "Entrepôt", 
            ID = 478, 
            Color = 40
        },
    },
    {
        pos = vector3(1240.64508056641,1867.31667480469,78.91048555374146),
        blip = {
            label = "Entrepôt", 
            ID = 478, 
            Color = 40
        },
    },

    {
        pos = vector3(1991.3577880859,3055.08984375,47.214057922363),
        blip = {
            label = "Yellow Jack", 
            ID = 93, 
            Color = 5
        },
    },
    {
        pos = vector3(-1387.7653808594,-589.22778320312,30.319463729858),
        blip = {
            label = "Bahama mamas", 
            ID = 93, 
            Color = 8
        },
    },
    {
        pos = vector3(-161.31555175781,-2134.4204101562,16.705043792725),
        blip = {
            label = "Circuit de Karting", 
            ID = 611, 
            Color = 1
        },
    },
    {
        pos = vector3(-699.54168701172,-943.44384765625,18.853332519531),
        blip = {
            label = "Station de Lavage", 
            ID = 100, 
            Color = 0
        },
    },
   
    {
        pos = vector3(-544.31201171875,-206.32037353516,37.969284057617),
        blip = {
            label = "Gouvernement", 
            ID = 419, 
            Color = 0
        },
    },
    {
        pos = vector3(556.13104248047,2674.8039550781,42.167980194092),
        blip = {
            label = "Magasin de masques", 
            ID = 362, 
            Color = 2
        },
    },
    {
        pos = vector3(-1337.4604492188,-1277.7769775391,4.8759136199951),
        blip = {
            label = "Magasin de masques", 
            ID = 362, 
            Color = 2
        },
    },
    {
        pos = vector3(-200.2129, 6352.457, 31.48807),
        blip = {
            label = "Magasin de masques", 
            ID = 362, 
            Color = 2
        },
    },
    {
        pos = vector3(150.266, -1040.203, 29.374),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(4477.0634765625,-4464.4365234375,4.2520751953125),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(-1212.980, -330.841, 37.787),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(-2962.582, 482.627, 15.703),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(314.187, -278.621, 54.170),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(-351.534, -49.529, 49.042),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(241.727, 220.706, 106.286),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(1175.064, 2706.643, 38.094),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(935.65551757812,46.530422210693,81.09578704834),
        blip = {
            label = "Casino", 
            ID = 679, 
            Color = 48
        },
    },
    {
        pos = vector3(22.181812286377,-1106.7244873047,29.797006607056),
        blip = {
            label = "Armurerie", 
            ID = 110, 
            Color = 40
        },
    },
    {
        pos = vector3(-1678.6433105469,-283.2109375,51.862335205078),
        blip = {
            label = "Los Santos Church", 
            ID = 89, 
            Color = 1
        },
    },
    {
        pos = vector3(-1830.644,-1190.003,19.9953),
        blip = {
            label = "Pearls", 
            ID = 267, 
            Color = 38
        },
    },
    {
        pos = vector3(1074.0068359375,-2008.7602539062,32.084987640381),
        blip = {
            label = "Revente de pépites d'or", 
            ID = 1, 
            Color = 60
        },
    },
    {
        pos = vector3(-2294.8874511719,2544.6606445312,2.6882951259613),
        blip = {
            label = "Recolte de terre", 
            ID = 1, 
            Color = 56
        },
    },
    {
        pos = vector3(-95.6748046875,-2767.8979492188,6.0821285247803),
        blip = {
            label = "Poissonnerie", 
            ID = 371, 
            Color = 3
        },
    },
    {
        pos = vector3(137.09083557129,-1708.1477050781,29.291622161865-0.98),
        blip = {
            label = "Barbier", 
            ID = 71, 
            Color = 51
        },
    },
    {
        pos = vector3(-810.96441650391,-184.06790161133,37.568992614746-0.98),
        blip = {
            label = "Barbier", 
            ID = 71, 
            Color = 51
        },
    },
    {
        pos = vector3(-1280.9237060547,-1116.8645019531,6.9901103973389-0.98),
        blip = {
            label = "Barbier", 
            ID = 71, 
            Color = 51
        },
    },
    {
        pos = vector3(1929.7789306641,3732.8803710938,32.844417572021-0.98),
        blip = {
            label = "Barbier", 
            ID = 71, 
            Color = 51
        },
    },
    {
        pos = vector3(1214.7652587891,-473.13641357422,66.207984924316-0.98),
        blip = {
            label = "Barbier", 
            ID = 71, 
            Color = 51
        },
    },
    {
        pos = vector3(-33.455024719238,-154.7061920166,57.076484680176-0.98),
        blip = {
            label = "Barbier", 
            ID = 71, 
            Color = 51
        },
    },
    {
        pos = vector3(-275.92349243164,6226.2612304688,31.695512771606-0.98),
        blip = {
            label = "Barbier", 
            ID = 71, 
            Color = 51
        },
    },
    {
        pos = vector3(4772.88671875,-4769.224609375,4.8551683425903),
        blip = {
            label = "Location de bateaux", 
            ID = 410, 
            Color = 3
        },
    },
    {
        pos = vector3(-1608.7741699219,5261.58984375,3.9741015434265),
        blip = {
            label = "Location de bateaux", 
            ID = 410, 
            Color = 3
        },
    },
    {
        pos = vector3(3858.3715820312,4458.4853515625,1.822195649147),
        blip = {
            label = "Location de bateaux", 
            ID = 410, 
            Color = 3
        },
    },
    {
        pos = vector3(4892.1928710938,-4924.2763671875,3.3666849136353),
        blip = {
            label = "Boite de nuit Cayo Perico", 
            ID = 766, 
            Color = 71
        },
    },
    {
        pos = vector3(-567.27972412109,5253.1845703125,70.46669769287169),
        blip = {
            label = "Chasse", 
            ID = 141, 
            Color = 17
        },
    },
    {
        pos = vector3(64.948173522949,120.54766082764,79.123374938965),
        blip = {
            label = "~r~Go ~q~Postal", 
            ID = 738, 
            Color = 1
        },
    },
    {
        pos = vector3(959.94, -2106.08, 31.5),
        blip = {
            label = "Boucherie", 
            ID = 141, 
            Color = 1
        },
    },
    {
        pos = vector3(122.83716583252,-1290.5177001953,29.269332885742),
        blip = {
            label = "Unicorn", 
            ID = 121, 
            Color = 48
        },
    },
    {
        pos = vector3(1768.4406738281,3328.0766601563,41.438526153564),
        blip = {
            label = "Concessionnaire de motos", 
            ID = 522, 
            Color = 63
        },
    },
    {
        pos = vector3(-1099.1721191406,-841.30792236328,19.001497268677),
        blip = {
            label = "Los Santos Police Department", 
            ID = 60, 
            Color = 29
        },
    },
    {
        pos = vector3(1854.0798339844,3685.1711425781,34.270111083984),
        blip = {
            label = "Los Santos Sheriff's Department", 
            ID = 60, 
            Color = 16
        },
    },
    {
        --pos = vector3(363.26422119141,-1587.8265380859,29.292051315308),--
        pos = vector3(-469.4134,5995.603,31.42537),
        blip = {
            label = "Los Santos Sheriff's Department", 
            ID = 60, 
            Color = 16
        },
    },
    {
        pos = vector3(316.58554077148,-587.35015869141,43.261268615723),
        blip = {
            label = "Pillbox Hill Medical Center", 
            ID = 61, 
            Color = 2
        },
    },
    {
        pos = vector3(1833.9340820312,3674.6765136719,34.277423858643),
        blip = {
            label = "Sandy Shores Medical Center", 
            ID = 61, 
            Color = 1
        },
    },
    {
        pos = vector3(-165.9265136719,306.5374755859,98.6938667297363),
        blip = {
            label = "Restaurant Japan", 
            ID = 770, 
            Color = 1
        },
    },
    {
        pos = vector3(-1222.2791748047,-1495.5054931641,4.3454494476318),
        blip = {
            label = "Location de vélo", 
            ID = 1, 
            Color = 46
        },
    },
    {
        pos = vector3(263.754785156,-1808.63540039,35.909698486328),
        blip = {
            label = "Hayes Autos", 
            ID = 446, 
            Color = 63
        },
    },
    {
        pos = vector3(1180.4283447266,2640.5002441406,37.753875732422),
        blip = {
            label = "Harmony Repair & Custom", 
            ID = 72, 
            Color = 66
        },
    },
    {
        pos = vector3(-1356.1695556641,126.37564849854,56.238754272461),
        blip = {
            label = "Golf", 
            ID = 109, 
            Color = 19
        },
    },
    {
        pos = vector3(-1254.567003631592,-358.3991699219,36.274415969849),
        blip = {
            label = "Concessionnaire de véhicules", 
            ID = 523, 
            Color = 28
        },
    },
    {
        pos = vector3(-717.93933105469,263.31057739258,84.099853515625),
        blip = {
            label = "Agent immobillier", 
            ID = 475, 
            Color = 2
        },
    },
    {
        pos = vector3(-722.02056884766,-1325.4019775391,1.596290230751),
        blip = {
            label = "Location de bateaux", 
            ID = 410, 
            Color = 3
        },
    },
    {
        pos = vector3(4902.4887695312,-5179.427734375,2.4881038665771),
        blip = {
            label = "Location de bateaux", 
            ID = 410, 
            Color = 3
        },
    },
    {
        pos = vector3(5118.8974609375,-4630.9091796875,1.4427399635315),
        blip = {
            label = "Location de bateaux", 
            ID = 410, 
            Color = 3
        },
    },
    {
        pos = vector3(228.36717224121,373.93322753906,106.11417388916),
        blip = {
            label = "Permis Chasse et Pêche", 
            ID = 267, 
            Color = 5
        },
    },
    {
        pos = vector3(-1153.9765625,-1425.6508789063,4.9544591903687),
        blip = {
            label = "Salons de tatouages", 
            ID = 75, 
            Color = 1
        },
    },
    {
        pos = vector3(1322.9339599609,-1651.7247314453,52.275100708008),
        blip = {
            label = "Salons de tatouages", 
            ID = 75, 
            Color = 1
        },
    },
    {
        pos = vector3(322.47463989258,181.18678283691,103.5865020752),
        blip = {
            label = "Salons de tatouages", 
            ID = 75, 
            Color = 1
        },
    },
    {
        pos = vector3(-3170.6804199219,1075.3693847656,20.829183578491),
        blip = {
            label = "Salons de tatouages", 
            ID = 75, 
            Color = 1
        },
    },
    {
        pos = vector3(1864.1744384766,3748.1657714844,33.031852722168),
        blip = {
            label = "Salons de tatouages", 
            ID = 75, 
            Color = 1
        },
    },
    {
        pos = vector3(-294.1257019043,6199.6538085938,31.488185882568),
        blip = {
            label = "Salons de tatouages", 
            ID = 75, 
            Color = 1
        },
    },
    {
        pos = vector3(5117.5629882812,-5190.728515625,2.3860244750977),
        blip = {
            label = "Location de voitures", 
            ID = 227, 
            Color = 1
        },
    },
    {
        pos = vector3(5056.400390625,-4598.2084960938,2.8897848129272),
        blip = {
            label = "Location de voitures", 
            ID = 227, 
            Color = 1
        },
    },
    {
        pos = vector3(4502.6147460938,-4540.5737304688,4.1137948036194),
        blip = {
            label = "Location de voitures", 
            ID = 227, 
            Color = 1
        },
    },
    {
        pos = vector3(-866.68444824219,-435.23483276367,36.639965057373),
        blip = {
            label = "Location de voitures", 
            ID = 227, 
            Color = 3
        },
    },
    {
        pos = vector3(275.48, -344.84, 45.17),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(450.49255371094,-1981.5919189453,24.401720046997),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(4520.2446289062,-4515.5434570312,4.4794492721558),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(317.68194580078,2623.5085449219,44.468318939209),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(1695.5538330078,4785.23828125,41.998600006104),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(-3149.12109375,1109.1549072266,20.853740692139),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(-281.02236938477,-888.16723632812,31.318021774292),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(1171.6912841797,-1527.8337402344,35.050930023193),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(-1212.2630615234,-654.24523925781,25.901279449463),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(-773.18029785156,5531.5561523438,33.478778839111),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(2588.4877929688,429.58520507812,108.61365509033),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(213.74040222168,-808.92565917969,31.014890670776),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(46.651126861572,-1749.4738769531,29.634466171265),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(-1883.1860351562,-320.08096313477,49.363353729248),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(1877.7213134766,3761.5708007812,32.949462890625),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(-234.75675964355,6198.4951171875,31.93922996521),
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 3
        },
    },
    {
        pos = vector3(1758.4465332031,3249.2683105469,41.727474212646),
        blip = {
            label = "Garage avion", 
            ID = 359, 
            Color = 63
        },
    },
    {
        pos = vector3(-1124.5469970703,-2883.9013671875,13.945912361145),
        blip = {
            label = "Garage avion", 
            ID = 359, 
            Color = 63
        },
    },
    {
        pos = vector3(-1004.821472168,-1397.5513916016,1.5953904390335),
        blip = {
            label = "Garage de bateaux", 
            ID = 356, 
            Color = 3
        },
    },
    {
        pos = vector3(72.254, -1399.102, 28.376),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(4489.3681640625,-4451.9497070313,4.3664598464966),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(-703.776, -152.258, 36.415),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(-167.863, -298.969, 38.733),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(428.694, -800.106, 28.491),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(-829.413, -1073.710, 10.328),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(-1447.797, -242.461, 48.820),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(11.632, 6514.224, 30.877),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(123.646, -219.440, 53.557),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(1696.291, 4829.312, 41.063),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(618.093, 2759.629, 41.088),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(1190.550, 2713.441, 37.222),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(-1193.429, -772.262, 16.324),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(-3172.496, 1048.133, 19.863),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(-1108.441, 2708.923, 18.107),
        blip = {
            label = "Magasin de vêtements", 
            ID = 366, 
            Color = 51
        },
    },
    {
        pos = vector3(908.54663085938,-176.61926269531,74.179534912109),
        blip = {
            label = "Taxi", 
            ID = 198, 
            Color = 33
        },
        
    },

    {
        pos = vector3(127.65286254883,278.76361083984,109.9739074707),
        blip = {
            label = "Mayans Motors", 
            ID = 446, 
            Color = 40
        },
        
    },

    {
        pos = vector3(176.85244750977,-1321.3796386719,29.363626480103),
        blip = {
            label = "Pawn Shop - Jewerly LOANS", 
            ID = 617, 
            Color = 5
        },
        
    },
--[[
    {
        pos = vector3(482.39965820313,-1885.2686767578,26.094753265381),
        blip = {
            label = " ~r~[FERME]~s~ El Rancho Atomique Repairs", 
            ID = 446, 
            Color = 73
        },
        
    },
    {
        pos = vector3(-1272.9989013672,-1530.0178222656,5.1540303230286),
        blip = {
            label = "Ring du boxe", 
            ID = 491, 
            Color = 49
        },
        
    },
    {
        pos = vector3(-38.568016052246,-1667.1199951172,29.41587638855),
        blip = {
            label = "Salle d'entrainement de boxe", 
            ID = 586, 
            Color = 49
        },
        
    },
    {
        pos = vector3(-92.1513442993164,2811.2138671875,53.33141326904297),
        blip = {
            label = "[REEDWOOD CIGARETTE] Recolte", 
            ID = 365, 
            Color = 73
        },
        
    },
    {
        pos = vector3(-2743.156982421875,2283.135986328125,19.80246353149414),
        blip = {
            label = "[REEDWOOD CIGARETTE] Traitement", 
            ID = 365, 
            Color = 73
        },
        
    },
    {
        pos = vector3(-2183.018310546875,-419.3420715332031,13.12006187438964),
        blip = {
            label = "[REEDWOOD CIGARETTE] Vente", 
            ID = 365, 
            Color = 73
        },
        
    },
    {
        pos = vector3(-2507.1875,3607.5942382813,13.909398078918),
        blip = {
            label = "[CHICKEN INDUSTRY] Recolte", 
            ID = 365, 
            Color = 73
        },
        
    },
    {
        pos = vector3(276.34027099609,946.13568115234,211.06282043457),
        blip = {
            label = "[CHICKEN INDUSTRY] Traitement", 
            ID = 365, 
            Color = 73
        },
        
    },
    {
        pos = vector3(236.48881530762,2571.7412109375,46.233951568604),
        blip = {
            label = "[CHICKEN INDUSTRY] Vente", 
            ID = 365, 
            Color = 73
        },
        
    }, 
    {
        pos = vector3(-493.89074707031,-2851.1750488281,7.2959322929382),
        blip = {
            label = "~b~[DIAMOND]~s~ Revente de pépites d'or", 
            ID = 1, 
            Color = 84
        },
    },
    {
        pos = vector3(-510.50866699219,-2867.4311523438,7.2959332466125),
        blip = {
            label = "~b~[DIAMOND]~s~ Poissonnerie", 
            ID = 371, 
            Color = 84
        },
    },
    {
        pos = vector3(-502.41256713867,-2859.509765625,7.2959332466125),
        blip = {
            label = "~b~[DIAMOND]~s~ Boucherie", 
            ID = 141, 
            Color = 84
        },
    }, 
--]]
    
}



Citizen.CreateThread(function()
    for k,v in pairs(Blips) do
        if v.blip ~= nil then
            if v.blip.ID == 361 then 
                local blip = AddBlipForCoord(v.pos)
                SetBlipSprite(blip, v.blip.ID)
                if v.blip.Scale == nil then
                    SetBlipScale(blip, 0.3)
                else
                    SetBlipScale(blip, v.blip.Scale)
                end                
                SetBlipColour(blip, v.blip.Color)
                SetBlipAsShortRange(blip, true)
                SetBlipCategory(blip, 8)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.blip.label)
                EndTextCommandSetBlipName(blip)
            else
                local blip = AddBlipForCoord(v.pos)
                SetBlipSprite(blip, v.blip.ID)
                if v.blip.Scale == nil then
                    SetBlipScale(blip, 0.5)
                else
                    SetBlipScale(blip, v.blip.Scale)
                end
                SetBlipColour(blip, v.blip.Color)
                SetBlipAsShortRange(blip, true)
                SetBlipCategory(blip, 8)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.blip.label)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end)