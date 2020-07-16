import numpy as np
import matplotlib.pyplot as plt
from skimage.measure import EllipseModel
from matplotlib.patches import Ellipse
from hashlib import sha1
import os, sys, socket
import sun

lookup = {
    "1d732bf251e74ed8db86e9e03b97fffa212c7c9f":  "capture1_1.jpg",
    "3f554757d20e46ec9b654353d1d94c35bb17942b":  "capture1_2.jpg",
    "973edd412ac8e0371af07ffd33ebee2c9a57dcf4":  "capture1_3.jpg",
    "a13aebe8298a0e3cab47cddfa6a12b59ac201c9c":  "capture1_4.jpg",
    "105adeada7a8fbae5a74ff0e72d207da8800ed8c":  "capture1_5.jpg",

    "acaa82ff7825e9a83c7a2965b03593ba7bc6d85a":  "capture3_1.jpg",
    "bf5421ec24b1ba57a57eaee9f4a5dd0ace84b2aa":  "capture3_2.jpg",
    "62e7dbb2161251f2b7175159145dbcb7d31f5f6f":  "capture3_3.jpg",
    "934afa7829621b540d42ef9f7ecddff79e6e6b43":  "capture3_4.jpg",
    "a3c8bcc01c50290542d873110d5bd8716395243d":  "capture3_5.jpg",

    "b4ff9f5f68a723ccc63219e16838e60944dc18af":  "capture4_2.jpg",
    "f7de73bec6e657ddf2cd0c012e675ebf988d3c56":  "capture4_3.jpg",
    "95e42ec9304903854b9ad1e73d1e21edbea3272a":  "capture4_4.jpg",
    "e6b2a1ad460ab9d00f6a9c1330d26ed33ac4b211":  "capture4_5.jpg",
    "45870fd3331ef8eeb7900ac6b770a60d88e44b00":  "capture4_7.jpg",

    "3d8c43e324832ef80077a3c637f86e3c6bf14c96":  "capture5_10.jpg",
    "3662ef9a225c120fabd61d17295a6baa86bf9261":  "capture5_6.jpg",
    "f5a7ba22e958e17d33e1cb913a3135c0adbd69a0":  "capture5_7.jpg",
    "49a9811b7d6039228b0c5122eb3dc63db9e04a73":  "capture5_8.jpg",
    "fec8973aa6a268a5edd05b48a060566abbd79d76":  "capture5_9.jpg",

    "77059b8075e8e08bab2675668ea9f109cd05014d":  "capture7_11.jpg",
    "2efc3a7aa2f1196a7df2b44f4e270a7a0cd7c6c4":  "capture7_12.jpg",
    "2148a224d62a8a8c31c11d8dca547886c07a7d9c":  "capture7_13.jpg",
    "8e94bcd96df249f1d776d87898d6e36fd2339e2f":  "capture7_14.jpg",
    "6626ad323ff4a18639cee92f016702ff1ede3dc9":  "capture7_15.jpg",

    "3efc98d4eddaffc3939b887d2e660a18af147179":  "capture8_16.jpg",
    "31cb177c35de53cf27bab8466b093d25ca3214fc":  "capture8_17.jpg",
    "67bf94cdbf2677e64a7526cc7feccf5ce5966a1a":  "capture8_18.jpg",
    "e6cc9b8ac11f34f413c576867ae0a0cc1537d9d8":  "capture8_19.jpg",
    "f2cdcb422252b89908531ebf429e9fcc9e2f1aee":  "capture8_20.jpg",

    "bdde6a476ef4d2566c67e52463612025e7816a73":  "capture9_22.jpg",
    "e1fa9a4ef041565e90eedba84d909f69953ae48f":  "capture9_23.jpg",
    "db7796df2af145f688cdbd9b4f2ba536c2aa39e3":  "capture9_24.jpg",
    "541ae355bca68b2d29935210386b4cb94bcf027f":  "capture9_25.jpg",
    "f3043ebead0c41f4438d36591b391a3109317788":  "capture9_26.jpg",

    "f47cd863799548c88a59bf1f7825c512554dc473":  "capture10_27.jpg",
    "f7898800e71ada8d24d5b9525fd4cf15b14290ed":  "capture10_28.jpg",
    "d9ce99ac10184a5e387e632a0cb733b41673e2d8":  "capture10_29.jpg",
    "d11390fae621988d98643a01dd97d509a9d87031":  "capture10_30.jpg",
    "616e0a143236d162310a99aa611c01f81e4ad790":  "capture10_31.jpg",

    "f77940ab92ed5bba72995d68bfc0d54e3f9af214":  "capture11_32.jpg",
    "da7d17c4213d219c78462b3dca4772b562e1bbf3":  "capture11_33.jpg",
    "03fccfa89aa9dcfca7cfb4e25506dc5e04381fa7":  "capture11_34.jpg",
    "db1a27c8c3227642a3123da4118978d2709545cd":  "capture11_35.jpg",
    "08245555fb99974aa54bbc319f468aed1017a2e0":  "capture11_36.jpg",

    "66a2cfe0135464b9983e35c82a7424274452ade4":  "capture12_37.jpg",
    "a87b49391b9d530255c2c63c6e95897a374cb8b8":  "capture12_38.jpg",
    "8c1053bc2855eca0ab129248a86913f6ab20cd77":  "capture12_39.jpg",
    "830e0cbcc58bdb211be5a2ce26033db9f881b5f1":  "capture12_40.jpg",
    "2ab6d54fa7c2c341ef22a19e1a961113def7d17a":  "capture12_41.jpg",
}

inputs = [
    "capture1_1.jpg", "capture1_2.jpg", "capture1_3.jpg", "capture1_4.jpg", "capture1_5.jpg",
    "capture3_1.jpg", "capture3_2.jpg", "capture3_3.jpg", "capture3_4.jpg", "capture3_5.jpg",
    "capture4_2.jpg", "capture4_3.jpg", "capture4_4.jpg", "capture4_5.jpg", "capture4_7.jpg",
    "capture5_6.jpg", "capture5_7.jpg", "capture5_8.jpg", "capture5_9.jpg", "capture5_10.jpg",
    "capture7_11.jpg", "capture7_12.jpg", "capture7_13.jpg", "capture7_14.jpg", "capture7_15.jpg",
    "capture8_16.jpg", "capture8_17.jpg", "capture8_18.jpg", "capture8_19.jpg", "capture8_20.jpg",
    "capture9_22.jpg", "capture9_23.jpg", "capture9_24.jpg", "capture9_25.jpg", "capture9_26.jpg",
    "capture10_27.jpg", "capture10_28.jpg", "capture10_29.jpg", "capture10_30.jpg", "capture10_31.jpg",    
    "capture11_32.jpg", "capture11_33.jpg", "capture11_34.jpg", "capture11_35.jpg", "capture11_36.jpg",
    "capture12_37.jpg", "capture12_38.jpg", "capture12_39.jpg", "capture12_40.jpg","capture12_41.jpg",
]

def linear_extrapolate(x, y, frac):
    x0, y0 = x[0], y[0]
    dx, dy = x[1]-x[0], y[1]-y[0]
    return x0+frac*dx, y0+frac*dy


def solve(filename, lat, lon, day, month, year, plot=False):
    # TODO Find Index of SHASUM from above table
    origName = ""
    with open(filename, 'rb') as f:
        data = f.read()
        h = sha1()
        h.update(data)
        chksum = h.digest()
        origName = lookup[chksum.hex()]
    vn = np.array([0,-1])
    
    idx = inputs.index(origName)

    eidx = [
        0,0,0,0,0,
        1,1,1,1,1,
        2,2,2,2,2,
        3,3,3,3,3,
        4,4,4,4,4,
        5,5,5,5,5,
        6,6,6,6,6,
        7,7,7,7,7,
        8,8,8,8,8,
        9,9,9,9,9,
    ][idx]

    # Each set start with North Tower, go clockwise
    ellipse_points = [
        np.array([
            (587,900), (615,832), (1147,601), (1215,626), (1467,1151),(1444,1219), (893,1472), (832,1447)
        ]),
        np.array([
            (1395,1303), (1347,1359), (739,1392), (684,1341), (665,755), (714,704), (1295,673),(1349,720)
        ]),
        np.array([
            (1445,859), (1468,925), (1198,1456), (1127,1478), (592,1193), (573,1122), (858,616), (926,596),
        ]),
        np.array([
            (611,848), (645,789), (1200,628), (1264,659), (1450,1207),(1419,1270), (835,1451),
        ]),
        np.array([
            (834,627), (901,604), (1432,835), (1461,900), (1225,1444), (1155,1471), (602,1217), (579,1148),
        ]),
        np.array([
            (956,1485), (883,1468), (571,960),  (590,890), (1087,589), (1155, 605), (1479,1086), (1465,1159),
        ]),
        np.array([
            (668,1324), (624,1262), (733,692), (791,651), (1363,738), (1407,793), (1271,1417),
        ]),
        np.array([
            (710,713), (766,669), (1342,718), (1389,769), (1352,1352), (1297,1401), (689,1347), (643,1291),
        ]),
        np.array([
            (1287,671), (1342,716), (1399,1297), (1354, 1351), (744, 1396), (689,1347), (661,763), (710, 711),
        ]),
        np.array([
            (1432,1247), (1391, 1310), (790, 1428), (729, 1385), (631, 806), (674, 749), (1241, 645), (1302, 681),
        ])
    ]

    x = ellipse_points[eidx][:,0]
    y = ellipse_points[eidx][:,1]

    xs = [
        (x[0], 1112), (x[1], 1279), (x[1], 1148), (x[0], 786), (x[1], 833),
        (x[0], 661), (x[0], 631), (x[0], 893), (x[0], 1153), (x[1], 1485),
        (x[0], 837), (x[0], 1160), (x[0], 1329), (x[1], 948), (x[0], 789),
        (x[0], 1118), (x[0], 1467), (x[1], 400), (x[1], 669), (x[1], 925),
        (x[1], 785), (x[0], 1507), (x[1], 789), (x[0], 1135), (x[0], 1430),
        (x[0], 544), (x[1], 1323), (x[1], 1034), (x[1], 1397), (x[0], 525),
        (x[1], 1159), (x[0], 667), (x[1], 1316), (x[1], 1050), (x[1], 1280),
        (x[0], 1499), (x[0], 1001), (x[0], 1331), (x[0], 1200), (x[0], 1473),
        (x[1], 460), (x[1], 932), (x[1],765), (x[0], 1097), (x[0], 1079),
        (x[0], 956), (x[1], 1269), (x[0], 1057), (x[1], 1508), (x[1], 1162),
    ][idx]
    ys = [
        (y[0], 345), (y[1], 1334), (y[1], 1454), (y[0], 625), (y[1], 1363),
        (y[0], 1681), (y[0], 1039), (y[0], 1255), (y[0], 1303), (y[1], 662),
        (y[0], 1367), (y[0], 1250), (y[0], 1054), (y[1], 458), (y[0], 1441),
        (y[0], 1236), (y[0], 901), (y[1], 1473), (y[1], 1558), (y[1], 1190),
        (y[1], 1090), (y[0], 560), (y[1], 1361), (y[0], 898), (y[0], 839),
        (y[0], 1234), (y[1], 938), (y[1], 1208), (y[1],1153), (y[0], 952),
        (y[1], 611), (y[0], 611), (y[1], 1003), (y[1], 1268), (y[1], 1408),
        (y[0], 480), (y[0], 821), (y[0], 828), (y[0], 861), (y[0], 1024),
        (y[1], 1055), (y[1], 815), (y[1], 620), (y[0], 1036), (y[0], 1009),
        (y[0], 1160), (y[1], 751), (y[0], 1620), (y[1], 753), (y[1], 626),
    ][idx]


    vs_c = np.array([
        xs[1] - xs[0], 
        ys[1] - ys[0]
    ])
    vs_c = vs_c / np.linalg.norm(vs_c)

    vnx_0,vny_0 = x[5],y[5]
    vnx_1,vny_1 = x[0],y[0]
    vn_c = np.array([
        x[0] - x[5],
        y[0] - y[5]
    ])
    vn_c = vn_c / np.linalg.norm(vn_c)

    ell = EllipseModel()
    if not ell.estimate(ellipse_points[eidx]):
        print("Estimate Failed")
    xc, yc, a, b, theta = ell.params

    camera_a = np.arccos(np.dot(vn,vn_c))
    if vn[0]*vn_c[1] - vn[1]*vn_c[0] < 0:
        camera_a = -camera_a
    if a > b:
        camera_e = np.arcsin(b/a)
    else:
        camera_e = np.arcsin(a/b)
    light_a = np.arccos(np.dot(vs_c, vn_c))
    if vs_c[1]*vn_c[0] - vs_c[0]*vn_c[1] < 0:
        light_a = -light_a
    
    hMin = 0
    mMin = 0
    minE = 0
    deltMin = 1000
    target_a = np.cos(light_a)
    for h in range(0,24):
        for m in range(0,60,5):
            a,e = sun.findSun(lat,lon,h,tmin=m,td=day,tm=month)#,ty=year)
            a_c = np.cos(np.radians(a))
            #print(target_a, a_c, e, h, m)
            if abs(target_a - a_c) < deltMin:
                deltMin = abs(target_a - a_c)
                minE = e
                hMin = h
                mMin = m
    light_e = np.radians(minE)
    
    if (plot):
        img = plt.imread(filename)
        fig, ax = plt.subplots(figsize=(15, 10))
        ax.imshow(img, aspect=1)

        # Plot the ellipse that matches the launch platform
        ell_patch = Ellipse((xc, yc), 2*a, 2*b, theta*180/np.pi, edgecolor='red', facecolor='none')
        ax.add_patch(ell_patch)

        ax.plot(xc, yc, "C1+")

        xc, yc = linear_extrapolate(np.array([vnx_0,vnx_1]), 
                                    np.array([vny_0,vny_1]), 
                                    np.array([0,1.3]))
        ax.plot(xc, yc, "C0")

        xn, yn = linear_extrapolate(np.array([vnx_0,vnx_0]), 
                                    np.array([vny_0,-100+vny_0]), 
                                    np.array([0,4]))
        ax.plot(xn, yn, "C0")

# Plot the shadow of the North tower and extrapolate
#ax.plot(x_north_shadow, y_north_shadow, "C1o")
        xs, ys = linear_extrapolate(np.array([xs[0],xs[1]]), 
                                    np.array([ys[0],ys[1]]), 
                                    np.array([0,1.2]))
        ax.plot(xs, ys, "C1")

        xsn, ysn = linear_extrapolate(np.array([xs[0], 300*vn_c[0] + xs[0]]), 
                                      np.array([ys[0], 300*vn_c[1] + ys[0]]), 
                                      np.array([0,2]))
        ax.plot(xsn, ysn, "C1")


        ax.set_title("Estimating camera viewpoint azimuth and elevation")
        ax.set_xlabel("x (pixel)")
        ax.set_xlabel("y (pixel)")

        plt.tight_layout()
        plt.savefig("image_analysis.png", bbox_inches="tight")

    return (np.degrees(camera_a), np.degrees(camera_e),  np.degrees(light_a), np.degrees(light_e),  hMin, mMin)

if __name__ == "__main__":

    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31345))
    Host_Server = os.getenv("HOST_SERVER", Host)
    Port_Server = int(os.getenv("PORT_SERVER", 8080))
    DIR = os.getenv("DIR", "/mnt")
    
    
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, Port))
    fsock = sock.makefile('rw')

    ticket = os.getenv("TICKET", "")
    if len(ticket):
        fsock.readline()
        fsock.write(ticket + "\n")
        fsock.flush()

    for ii in range(0,3):
        info = fsock.readline() # image (lat,lon) day-month-year
        fsock.readline() # prompt
        image, pos, date = info.split(" ")
        lat,lon = map(float, pos[1:-2].split(','))
        day,month,year = map(int, date.split('-'))
        #print("Solving:", image, lat, lon, day, month, year)
        ca,ce, la,le, h,m = solve(DIR + "/"  + image, lat, lon, day, month, year)
        #print("%f,%f,%f,%f" % (ca,ce, la,le))
        fsock.write("%f,%f,%f,%f\n" % (ca,ce, la,le))
        fsock.flush()

    res = fsock.read().strip()
    print(res)
    sys.stdout.flush()

