module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<5x2x2x7xf32>)
    %2 = call @expected() : () -> tensor<5x6x7xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {indices_are_sorted = false, scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf32>, tensor<2x2x1xi32>, tensor<5x2x2x7xf32>) -> tensor<5x6x7xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32>, tensor<5x2x2x7xf32>) {
    %0 = stablehlo.constant dense<"0x3705573FB4C2B940274E0CC0C4798AC0C867AD4005E5FF3FFECD98C0A76022C0554485BEAAC9CDC019A82240A7295C400DD3A7BED96F41C0247CDB40617E6EBF3487383F8E7B6740417853C0B5D42BBE15687B401EB0313E63DDCD3FC6D47C40312768C0B377A13FFD4C28C0F652C2BDD974933F2FD0B6C0725906400C3601C0F64F17BF6EE7044007BF8EBF000A2BC010CA483F6B9B84C099CD3C3FA58F36C0517644403D8A20408E23D73F323D954050E93440944604C0592C86C03916D3BF4AD3E83E27C96D403E06A63FD253ABBF992CCABD9DC4DDBEFC185ABFBF26833FD9E558C009202E419D4EF73EEDDF23BF454566BDA57427C0A787EABF0414FCBD28CA5EC02BE10FC0966BA7C0B881AABFD8D54B407072A3C0691F34C02A4C1C40197E38BFB93F5D3FEF514E40C846C2BF6FF73EC02C1E3440820E5EBF4BDA8C40579554406AC74FC05C9CD5BF36E0E7BF22D68AC0E12E4B4084DFC3C07B0F40BFF6576B3FB53486406F9CA5BFB146713FBB28BC3F148331C0A69DEB3E89F1B3C013DFF7BD2ADF3EBFE6877AC0A7CC95400568323FE8301D3F47A97C3F38329DC07DF7584000A35BC06B5C1C3FFC474E40E34FF73F44188B400A307D3FBB9DD7BFD2FF28408FC5DBBE1E65B4BFD18E0A3F8F2B25C0EF90E1BF67AF09BF99E4F93FC33D6BC0D8569F3F5353DBBF5B5B68C048F3B2BF002E3BC03F5DBEBF2A1966C07BF143407A390340C38525C0657054C0280B2A405CFC2D403917D8404A92013F75C4A5BF45AC9D4047B1843F17AD5CBFF3967740C37F19402913ED3FE9088CC0FD61ABC01D7C313D8ACF0E3F8F6F21C01A2E8240EDC7833D927898BF1350C43FE56AA53F857DC0C0624A894040A7CB3F628A063F7582A73FD7E1DD3FB2FD15401B01C43FE0CB244014AAA43F84927CC0DD9966C01DBE3540AD9D1240B53C60C0A49BDDBF2586F73F265A13C038F525BE9594973F876D0D3FC749CAC050E899BEB2B5E93FCBE589BFB802F340D77046C031BE25C0B7D69BC06088B4BF460D5D3F54F822C0BD996C3FA8ADD240C79EF3BFF78DAEBE0A630D4030A6C73F0163D63F3DFA08BFC43D7040F8059E40BF62744049EF0CC09CEC79400BC14240DD791E40782468C03A7EAD3F2B0A3A40A6135AC0F1A6953FE16E26C0E1595BBF900520C0B82D3BC06C8734C0"> : tensor<5x6x7xf32>
    %1 = stablehlo.constant dense<"0xFBBB5EC0690C8DC04BBB5940AD3B1F40E2CD3E4061B21F407C6627BFEE543FC032AADE40DAD3743F282C8F3D98BE65C0159F2B3FE836F2BE3C3A894090B42EC09CDF6DBCD3681A409B36C93F1F304B40C497B73FAC5B58C031DA64BE8CFB293EBB97F8BFED9A62401FF822BF166D5A40DBBFA7BEEC9D0B40A5FF5A40D74DAFBF1F5875C02ACF9FBD4EBB7E3F7F712CC0866E9340EC899B40E97B47C0562227C0DAD59140281CC33F040DBE3E8314A33E53E2844013C17B4042E124BFCA935A3F4F3CF9BF4D8A37C0566989C0C520A63FD7E2093F144C153E34F592C0C8E9DBBFA0E599BFF71A6040F79FAD3FDFA668C0B3D341BF523DB23F9D0311BE3743AEBFC96BA0BE1C24623F2F0719BF8A2229C01A9A8E40554A5C40CE910C40C8E1DE3F9C7CEDC004DE11C0658FFF3F4E5FC8BEC38C02404099A34096B5F83E1DE7D03E7261F33F5D8680C023BABFC00455E6BE5C8A81BFBAC9653F108D04C01BF822BF64449340B732AA3EB13358BF875E88C08ADB10BF8E420A417D171FBF5874393FF4B39BBE2DCD02BFF1FF4BBF84AE37C0AB878EBFBB6B34C04E03B4BF5CE8ADC01F49D9BE61C961BE2D5EE93E3566244024C3D0409E32ACBDAA8E8FBF32D1533CB67A28BEB860B9C04BBE91C05AE78F3F4323F23F4B03913E34D5484092BF45C030636BBF2C6E31C089553B3EED4109C1ACD04E40C54C8340C12FF83F46BD58C0CA2EDFBE7B7919C05452CF3C274AF2BF5221813F8F7C81BFC05C5FBFB47564C00ED4E63E8F32BA3D2D2F7AC036EEB340"> : tensor<5x2x2x7xf32>
    return %0, %1 : tensor<5x6x7xf32>, tensor<5x2x2x7xf32>
  }
  func.func private @expected() -> tensor<5x6x7xf32> {
    %0 = stablehlo.constant dense<"0x69143BC07DB2CCC1CBA9EEC0D1432CC17C3E81418CA19F401AD74740F7B7F240B6D3E7BF82CEC4C0E9EF353E2C9545C1870461BE3805B73FBA4EEB411DC2224059762BBC1C9F0B418636A6C0F86108BF724CB4403A2C16BFA208B8BEE6E0273F906FE14064ED8E40AE47D63F74CDA5BED974933F2FD0B6C0725906400C3601C0F64F17BF6EE7044007BF8EBF000A2BC010CA483F6B9B84C099CD3C3FA58F36C0517644403D8A20406DF90CBF95C8224157C31A41EF283540A19680419FC5033EFDABE73E922C20C1863ABF401C30D0C0868A9D3E01C9903FAE7C78C0E0E9C73F9E05A1BFB3D85D402D5F0040252821C0FE4E143D01FA0EC0325564407DBAB43EB62B6F41D9BC3AC0DA5934C058E046BE64066AC129680C41691F34C02A4C1C40197E38BFB93F5D3FEF514E40C846C2BF6FF73EC02C1E3440820E5EBF4BDA8C40579554406AC74FC05C9CD5BF36E0E7BF05EDA6406CDE314171D804C1398B2E40EF2F32BF97E1BA40E39F3B3E663DA4BF5BD1EBBEC2CE1CC0D5D78CBE75C56D41F2120ABF343F24C0029109C1976B02412481A5C00D22B3BF243AFC3F8313F63FF449DD40445C8CC171E8973EB754A83FF81E6B4046AA8BC1EF9EBDC051FF413FD2FF28408FC5DBBE1E65B4BFD18E0A3F8F2B25C0EF90E1BF67AF09BF99E4F93FC33D6BC0D8569F3F5353DBBF5B5B68C048F3B2BF002E3BC0BFA7C03FD4894EC0F7E8CAC01913A7BF0E703EC1B93C8DBFC09B0FC09F5C39C1C18C74C017F58B4075084E3F4C7264403969A1BE8681E13E3B4C45C0F145DCC044FE03C0646245413906F140F02371BE6D6D72BE0A620E3FB357ED3F6241293E60ACF8C09E0C04BECA85B9BFC1449FBD624A894040A7CB3F628A063F7582A73FD7E1DD3FB2FD15401B01C43FE0CB244014AAA43F84927CC0DD9966C01DBE3540AD9D1240B53C60C05DD8913E753D33C12FC72741EA933ABE565F0F40B639203E1CB29EC1E3C56D3F57E4D6BF74263F402ED4B13FFBCAD44125E605C137DB9FC1CA052FC0A2263BC01A148E3F28D80DC02C9E2A3EA99266408318B0BE66070FC01932AEBFBF52BFC0930477BE53BCAE3EF36E9AC173C4AB4149EF0CC09CEC79400BC14240DD791E40782468C03A7EAD3F2B0A3A40A6135AC0F1A6953FE16E26C0E1595BBF900520C0B82D3BC06C8734C0"> : tensor<5x6x7xf32>
    return %0 : tensor<5x6x7xf32>
  }
}