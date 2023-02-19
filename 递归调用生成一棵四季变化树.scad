// OpenSCAD 为免费开源的跨平台建模软件
// 作者：上海市第三女子初级中学 谢丁
// 请使用视图菜单下的动画命令打开动画设置，建议将步数设置为100，帧率设置为25，看四季变化
// 树木生成官网参考链接 https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/User-Defined_Functions_and_Modules#Function_Literals
// 颜色参考链接
// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#hull
color_season = ["GreenYellow", "LimeGreen", "Crimson", "SandyBrown"];

function colorName(x)= x < 0.25 // 随时间变化的色彩
        ? color_season[0]
        : x < 0.5
              ? color_season[1]
              : x < 0.75
                    ? color_season[2]
                    : color_season[3];

$vpd=600; // 设置摄像机距离
// 打开视图动画功能，这里在动画期间，以绕x轴旋转90°和z轴旋转360°为例
$vpr = [$t * 90, 0, $t * 360];

module simple_tree(size, dna, n) 
{ // n 是树的深度
  if (n > 0)
  {
    // 树干部分
    color("BurlyWood")
    cylinder(r1 = size / 10, r2 = size / 12, h = size, $fn = 24);
    // 枝干部分
    translate([0, 0, size])
    for (bd = dna)
    { // 六叉树，dna是枝干数据，可以从dna列表中删除或添加枝干
      angx = bd[0]; // 枝干的倾斜度
      angz = bd[1]; // 枝干沿着z轴旋转角度
      scal = bd[2]; // 枝干的缩放比例
      //rotate([angx, rands(1,10,1), angz]) // y轴方向可否随机旋转1~10° ？
      rotate([angx, 0, angz])
      simple_tree(scal * size, dna, n - 1);
    }
  }
  else 
  { // 树叶部分，树叶数目与枝干数一样多
    color(colorName($t)) // 选择树叶的颜色
    scale([1, 1, 3])
    translate([0, 0, size / 6])
    rotate([90, 0, 0])
    cylinder(r = size / 6, h = size / 10);
  }
}

dna = [ [12,  80, 0.85], [55,    0, 0.6],
        [62, 125, 0.6], [58, -125, 0.6], [35, 18, 0.35],[-10,26,0.5]];
simple_tree(50, dna, 4); // 受到计算机性能影响，这里树的深度设置为4，建议不要超过10