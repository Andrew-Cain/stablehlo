module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xcomplex<f32>>, tensor<1x20xcomplex<f32>>)
    %1 = call @expected() : () -> tensor<20x20xcomplex<f32>>
    %2 = stablehlo.broadcast_in_dim %0#1, dims = [0, 1] : (tensor<1x20xcomplex<f32>>) -> tensor<20x20xcomplex<f32>>
    %3 = stablehlo.real %0#0 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %4 = stablehlo.real %2 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %5 = stablehlo.compare  EQ, %3, %4,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %6 = stablehlo.compare  LT, %3, %4,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %7 = stablehlo.imag %0#0 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %8 = stablehlo.imag %2 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %9 = stablehlo.compare  LT, %7, %8,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %10 = stablehlo.select %5, %9, %6 : tensor<20x20xi1>, tensor<20x20xi1>
    %11 = stablehlo.select %10, %0#0, %2 : tensor<20x20xi1>, tensor<20x20xcomplex<f32>>
    %12 = stablehlo.custom_call @check.eq(%11, %1) : (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) -> tensor<i1>
    return %12 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xcomplex<f32>>, tensor<1x20xcomplex<f32>>) {
    %0 = stablehlo.constant dense<"0x684D0BBFC2FA4F4006C2264049CF1440206CC6C0381AAE3F611BD63F8B80B13F91DD884043C146402EAA6B40ECF06ABF1391C5BFF4A76BBF8CBAC9BF2EFC2440E52AAEBF304EF2C0FF1129C0462FE83F32E1D33D8AD5EE3E62A38240EB01E03F4B342DC0DE948BC0A11AB9BF3C6143409AD0BD40EB76F2BFF98EECBFD98CB23F3BF0F23DE450B0409E7FE540E5470DBF040DC23FA5E304BFFFB65EC0F10344BF8BB08BBFAC1C8AC0856565C07BD1793E80D341BE9733224065B8A0BF87D911C03EA539C0EFB52DBF6CF08540669517BE79B28DBEC25E9CBFAC05D9BFC0E22FBDD41E973F8F39F4BEF5494F3F15B365C0F36FD6BFCC8E7FC0D4EEBC4070B667C0921DA5409BC5E63F6CE478BF7FA9F5BFFF7AD440B3E1CA3EAE7B10C0FCA92FC0EE8DAC40E25E294080214B40F18C4140C9BB95BF46BE5AC079406340D9E1A7BFB9F88040E68B0B3F1B8759C06201AEBE23CA59403A8FE1BF3F9098C0C6538A3DD054924056190AC07E609C3F855F2140918E7040785D9840818DF93F438AD83F0F164DC05127343E0C37F2BF79D0424067968DC049756D404615814009CA1C3FB413513FD0E806403B47E1BD2B4C273F883E38406DA1B63F498233C06BB811C0CF146D40DC1B1CC01DC25B4090B84A3FF31CEE3FD1F4B7BFA84217BEAEEE8FC04608914032230ABFF421C3BF35132F40A8D67040252C463D2E9E1CC011781D4041C286BDC4CFB5BEA869B03F0DC3963E74389DC03F51383F92B8563F22980B40BCCB913F46F80BBF803B79C0462246C046F732BF7B20CD3F44E324BF6F8CBCBFE4CF6540D9EA7D4081FDDFBFF7431C40F4B0E2BEEF409F4039BF27C0507A0740E9C0FD3DDE0CDC3F5634A4409E5686BF4F5B1D3F4F21A63D08511B409AFC6CC0993B1C3F945030C04F67C440BFBBB9C026A4973F6B44CFC087D412C0987931C049D87A405BEE56BF05C5043FE9D3D83F8387A7BEEF7A7E40F9628840DE3D8BBF9F85BDBE6F1F34C00362643EAA06E940BF7F28C0FE75414074F8F53FE33401C0BA04FFBEECF1094087B88A4070615FBEF7A0933FAD1F5BBEC91BF93E849781C00F84E23FB47AB0BF0E1800BF7A8EF2BFBAD62DC0F61E5740C88EEEBF02324C40FA7AB64056E608C129515DC04F8B5B3E406326BFC106A73F28705FBE2DEA53C0D5D415C0D330BBBFB95814C0DA26E53FFF6BD8BF4647E13F8025D23F5AC1F7BF37545240045D4CBF9C6974401097383D5F50703FFBCF1BC0FF082D4091A9B73F2A94BBBFAEFF29BFDD2347BFBE73833FDB545F40DC6CB1BE124248406BA1073F8F111BC028C3094090D1C33DEAFEFABE1523803F21232CBF24BCC9BED25467C043E912C07D7D154067F18240F47C19C0B6B037BF373BB5BECE3517C00B815EC0EEEA0F40033E57BF3A90B0C084DC903F65EAD5BF927F243E4439104089980BC0C01A333C1C835740E1CF3EC0A7FC31BF2054863FDBFA0D40E635943F2FDFA93F00678EBF864094C08BA19D401A6D50C009E095C01ABC28402AD91AC02420DF3F78498B40726C463EAE152740750C69406B2D5CC04E96373FF90794BF2641E03F58725440F4D70340A2AF223FE61C3940310A38BFF9978E3F247F35C0179E87C00D387340E3F01EC069F85D3E510A0A40CCF511BFFC86163F24C2B83DF56CE43F35A74440634ADD3D9EC10ABF2EDC35C065F4E13F88719540AD4556C0773B2A409F88184026A1D8BF49BCE8BFB194DE3FFDC1373D1F60743F27ADAFBE952E3B407A619F403E711A4035805040FCC2BDC0BC0C72BFA895CC3F67A38D400344C83F25846BC0B1780ABE2024AEC0FAE0D4BFC315CABF299382C028BBDA3F908728BD156B6FBF83E837C0A6D030C08C7837C0C99CF2BF911D18C0EE3A9BC01A3B10C09EFED03F32223FC0E993223DAF7BB5C08FD4204051C7D44035A905402079DC3F0F092640F6D309C08AA2A63F8C6E134063B565BED808FC3F373158BF06CC2ABFA51FF0BF645246C06112A9BF45A2EA3F013E2BC0ECCB3540785324C093DFD3C0186117BFAEDF8CC0D96AC9BF30C868C085EE82C07066DDC03C9A793FB9A166C0FC1130C06DF31EC0A8CB313FF327183F8B27F53FCE2490BFE8043B409AF8B7BE7F904DC0A64224C02C1484BEE2F9E13FE8FB3EC04A0BBA3F00972F3CF14C76C096FE89406D1FBCC041D26CBF901D68C04FA23AC0D101EAC00F8C934064A5AEBE3E24793F06E4ECBE350890402C8B163F4CDDE0C0EACC9CC023509CC02868A1C0D52220C06606A23F58EE8A40BF2A52C0A126BBBFB8E4203F0A95063FA84D80BF8935E7BFED02E84069CC1E40853FFDBFF18B1240FC75BF3FCC65EBBF3FE253BF108136BF0200F5BEE678F4BFD74AA3BF519CEABFB78A8740A3C31A4024A7C1BEC807EBBFD6048C3ED045AAC04819A9C0CFAA5DBE93AB20C06ABC29C0CA08043F29B68F3F9F3F43C0CDAEB940EFA56C3F781BCA3F7984B2BF939C88BE2E2F41404246B0BF479D3ABF86FB17BF1E7DA14098FBDF40654ABD3FF12743C0B81210C08CB72C40FC53223DE52BA2BF6D58FABFDFE6CA3FE2EF6040B023BA3FF87C673FD1A5D4407021DDC016648F3F9F741AC0438F93C04D01B840B1C0DDBFE1E78CBFFB27B4402B7F473FB7750FBD70B41541210A1940CA382CBFA31F9EBE3BDA5C40994B4340F0A4DA403202C840887C1940FCF513BEC8B68340EF587CBF5239B73FE9DACB3FA1662C3FACF516C02B8599BFE430CFC073D9D73FBDEC2B40AD4C3B3F2D3D854032E79EC07516EC3F08816C3EA8FBDABC9CF88F3E696F66C0E2EA263F0DB724C0FFBF1740DC9C09BF266CF93F56F482C091F7303F375281C08A430EC00B8A80C04224A23FF61DD73FA0C163C028125E400D3400406C8B9640FB163CC0F6239140F1382BBF2CB337C0366974C0DE2C83BF1EDDB3BF2A9670C038798A3E097E0FC0ACC42840B7DFC23F76ECD3BF91C1A2BFB72FBCC0FE08AEBFFDD1C8BF7B12D13F284D47402A903140D547D440625884BF35BB16C060F0A0BB24F77BBF41BCC9BF78410D41D8C9B74013A306C0FDBCD4C02FB16840BFEFC3BFAEF88840B1C38B3FEDC3A13F0BD93BBE117CA73F164CE03F74A7A33F15EAFB4007FA02402BC3B6BFD48250C031040DBEC8A788BF33114440C8C211C1322B933F119DBE405D42C0C0CB928EBFF4AC7EBF930D154065F6EFBFD12101C0B0D19BC0D50131C038FF203F420AB8BE63D46BC0432A12C0ADC870BF29A2823EDC9988C00FB23F4006F116405FB10B4055C456BFBC2535C0DF2725C0D066D7BFD9C934C0C2F1AFBFFB614CBEEBAD53406B6FB5BF03352BBFD851E7C01A5C8BC0EF888F3FAC494EC00DEA35C0DDA6D6BDD9F7134066ED44C026E5F1BFF1A07140D711AAC0B107DC3FC967593F45C385C0E4C8CE3FB1755F3F18E92CC0701B53401C6867C049C60B401FF74540313280BF615BAE3F46EF17C0A3F85440B6A56BBF509911BFFDF08AC055FE39C06D5261C049AA7EC06CFBDE3F5AA3BCC0C0FF27BFBA2F983F2822B7C061DE6FC040C01EC0A3004140C94B01BE27CD023E2956C4BED6F93640CC5D4D40BB348DBFA6C72FC089A9A9400E1CE43D8E693FC0134341C0D526EE3F0A652EC00403084068575240ED3C3FC095580CBF09242B4065BA9140849A84C0E1978B3D0C2E19C06F45BBC0A29D69C06BE346C0664BFF3F3F30C2BFAA8818BF4F33ECBFB25294408EF8AFC0CA14FF3F4E26E9BE1C63A93F3AE947C089E9BCBF86ABDF3F7EF0164070C3843DD37B88C0FBFA7940B6E1DCBF0202D53F305068C07D7AF8C00D2B953F5E14BBBF244243C00CF8CB3F77BE733FAD8B1BC041D67CC0C504EE3F8CF86440E82AF2BFD59FD13F8B3E3FC01FBEECBE0DFE0AC12E85303FF7DFB9400C328FBFA7B7ADC05980A3401E6D43C04C471240B69D91C0BFF3573F10DFD9BF9EFE41401E3140C06D046F409BBA40401A99224063D1D53F05E7403FACECD8BFC2B532C082B8CF3F5C1D86C0AED3B7C03AE348405E30A6C0DC801FBF0CA7493E294A77BE5D6C68BF9F62AB3FD403D03F34CB9F3F58F409C0918783403F6F99405887F03FBB68B3401780364062B7933FDB676AC0A55470400D8FEFBEEE33D640278300C062EC89C0E0EE68C0C78E953F956D394089C8723F395CA43F9CEFDBBFB129DDBE829480C023AE943F832C92C020C32A3F1A3EE2BFDADA873F2A972040738D88C099B633C0BC47D5BFAEF39EB97AD832C04C0A723F3728BEC0CC94A7BF70A05ABF2432A4BF429BD93DD370A83E8BE1DB3FC34DA5BE419D4D40E9BDE3BFB614D83F79EF424011830340A6C765C08BE9A93E8E2B553F01892C4098857740052492C0C74A4F40DC009B3E284D36BF7DCA25BF778D1F403B6F84C0E9E331BF654D51BF5C886040632DA33FEC3D0BC043DAAE40F92CA33FD82510401CE4BBBFAEBF96BE1DD64D406010853F0D1612BFEB7A493FECE83C3EBF3ECF3EA86D6DC0EDCCA8BFBFEB883F7BEC89C0239E593E69768440EF1BFFBE023F293DA1094140"> : tensor<20x20xcomplex<f32>>
    %1 = stablehlo.constant dense<[[(5.88663482,-2.55371547), (0.648939073,-1.37399912), (-2.79467869,-1.16459846), (1.47420871,-3.08410072), (-1.37566876,-2.32556534), (1.1311872,0.497200131), (1.68349206,0.545473754), (-9.13706874,1.4789294), (-1.84309328,4.83583069), (3.51301336,2.55756855), (2.46742702,-3.11607575), (-2.54247546,-0.946420133), (-0.355785102,-2.79346275), (1.55207503,-3.6161778), (-4.06739902,2.09621119), (2.28967428,-3.11662507), (-3.03409266,0.397160977), (-0.915789246,4.41259336), (-2.73107529,-0.25966391), (0.741804301,-2.29866171)]]> : tensor<1x20xcomplex<f32>>
    return %0, %1 : tensor<20x20xcomplex<f32>>, tensor<1x20xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x684D0BBFC2FA4F40DF20263F34DFAFBF206CC6C0381AAE3FDFB2BC3FE86145C0EA15B0BF10D614C0BECA903F0491FE3E1391C5BFF4A76BBF6F3112C18F4DBD3F7BEAEBBF20BF9A40FF1129C0462FE83F32E1D33D8AD5EE3EEBB722C0974872BF4B342DC0DE948BC0A11AB9BF3C614340222882C053280640F98EECBFD98CB23F932E42C0AF58CB3E2A716ABFF7338D40F0C92EC0ABF284BEFFB65EC0F10344BF8BB08BBFAC1C8AC0856565C07BD1793E04DC32C0901195BF65B8A0BF87D911C03EA539C0EFB52DBFBECA903F0491FE3E79B28DBEC25E9CBF6F3112C18F4DBD3F7BEAEBBF20BF9A40F5494F3F15B365C0F36FD6BFCC8E7FC0EBB722C0974872BF7729B6BE18C832C06CE478BF7FA9F5BF222882C053280640AE7B10C0FCA92FC0932E42C0AF58CB3E2A716ABFF7338D40F0C92EC0ABF284BEE3E63D3F461D13C0B9F88040E68B0B3F1B8759C06201AEBE04DC32C0901195BF3F9098C0C6538A3DEA15B0BF10D614C0BECA903F0491FE3EAB7CD73F2BA40B3F6F3112C18F4DBD3F0F164DC05127343E0C37F2BF79D0424067968DC049756D40EBB722C0974872BF7729B6BE18C832C03B47E1BD2B4C273F222882C053280640498233C06BB811C0932E42C0AF58CB3E2A716ABFF7338D40F0C92EC0ABF284BEA84217BEAEEE8FC04608914032230ABFF421C3BF35132F4004DC32C0901195BF2E9E1CC011781D40EA15B0BF10D614C0BECA903F0491FE3E74389DC03F51383F6F3112C18F4DBD3F7BEAEBBF20BF9A40803B79C0462246C046F732BF7B20CD3FEBB722C0974872BF7729B6BE18C832C081FDDFBFF7431C40222882C05328064039BF27C0507A0740932E42C0AF58CB3E2A716ABFF7338D40F0C92EC0ABF284BEE3E63D3F461D13C0993B1C3F945030C0DF20263F34DFAFBF04DC32C0901195BF87D412C0987931C0EA15B0BF10D614C005C5043FE9D3D83F8387A7BEEF7A7E406F3112C18F4DBD3F7BEAEBBF20BF9A400362643EAA06E940BF7F28C0FE754140EBB722C0974872BFBA04FFBEECF1094065AAC63F756F67C0222882C053280640C91BF93E849781C0932E42C0AF58CB3E2A716ABFF7338D40F0C92EC0ABF284BEC88EEEBF02324C40FA7AB64056E608C129515DC04F8B5B3E04DC32C0901195BF28705FBE2DEA53C0D5D415C0D330BBBFB95814C0DA26E53FFF6BD8BF4647E13F6F3112C18F4DBD3F7BEAEBBF20BF9A4036D5604034AF23405F50703FFBCF1BC0EBB722C0974872BF2A94BBBFAEFF29BFDD2347BFBE73833F222882C053280640068A1240C97647C0932E42C0AF58CB3E2A716ABFF7338D40F0C92EC0ABF284BE24BCC9BED25467C043E912C07D7D1540DF20263F34DFAFBF04DC32C0901195BFCE3517C00B815EC0EA15B0BF10D614C03A90B0C084DC903F65EAD5BF927F243E6F3112C18F4DBD3F7BEAEBBF20BF9A40E1CF3EC0A7FC31BF2054863FDBFA0D40EBB722C0974872BF00678EBF864094C065AAC63F756F67C009E095C01ABC28402AD91AC02420DF3F932E42C0AF58CB3E2A716ABFF7338D406B2D5CC04E96373FF90794BF2641E03F58725440F4D70340A2AF223FE61C394004DC32C0901195BF247F35C0179E87C0EA15B0BF10D614C069F85D3E510A0A40CCF511BFFC86163F6F3112C18F4DBD3F7BEAEBBF20BF9A409EC10ABF2EDC35C065F4E13F88719540AD4556C0773B2A407729B6BE18C832C049BCE8BFB194DE3F222882C05328064027ADAFBE952E3B40932E42C0AF58CB3E2A716ABFF7338D40F0C92EC0ABF284BEE3E63D3F461D13C025846BC0B1780ABE2024AEC0FAE0D4BF04DC32C0901195BFDFB2BC3FE86145C0EA15B0BF10D614C0A6D030C08C7837C0C99CF2BF911D18C06F3112C18F4DBD3F7BEAEBBF20BF9A40E993223DAF7BB5C053EA1D40C96D47C0EBB722C0974872BF7729B6BE18C832C08AA2A63F8C6E1340222882C053280640373158BF06CC2ABF932E42C0AF58CB3E6112A9BF45A2EA3FF0C92EC0ABF284BE785324C093DFD3C0186117BFAEDF8CC0D96AC9BF30C868C085EE82C07066DDC03C9A793FB9A166C0FC1130C06DF31EC0A8CB313FF327183FAB7CD73F2BA40B3F6F3112C18F4DBD3F7F904DC0A64224C02C1484BEE2F9E13FE8FB3EC04A0BBA3FEBB722C0974872BF7729B6BE18C832C041D26CBF901D68C0222882C053280640068A1240C97647C0932E42C0AF58CB3E2A716ABFF7338D404CDDE0C0EACC9CC023509CC02868A1C0D52220C06606A23FDF20263F34DFAFBF04DC32C0901195BF0A95063FA84D80BF8935E7BFED02E840BECA903F0491FE3EAB7CD73F2BA40B3F6F3112C18F4DBD3F7BEAEBBF20BF9A40E678F4BFD74AA3BF519CEABFB78A8740EBB722C0974872BFC807EBBFD6048C3ED045AAC04819A9C0222882C0532806406ABC29C0CA08043F932E42C0AF58CB3E2A716ABFF7338D40F0C92EC0ABF284BE939C88BE2E2F41404246B0BF479D3ABF86FB17BF1E7DA14004DC32C0901195BFF12743C0B81210C0EA15B0BF10D614C0E52BA2BF6D58FABFDFE6CA3FE2EF60406F3112C18F4DBD3F7BEAEBBF20BF9A4016648F3F9F741AC0438F93C04D01B840EBB722C0974872BF7729B6BE18C832C0B7750FBD70B41541222882C053280640A31F9EBE3BDA5C40932E42C0AF58CB3E2A716ABFF7338D40F0C92EC0ABF284BEEF587CBF5239B73FE9DACB3FA1662C3FACF516C02B8599BFE430CFC073D9D73FDFB2BC3FE86145C0EA15B0BF10D614C0BECA903F0491FE3EA8FBDABC9CF88F3E6F3112C18F4DBD3F0DB724C0FFBF1740DC9C09BF266CF93F56F482C091F7303F375281C08A430EC00B8A80C04224A23F65AAC63F756F67C0222882C053280640068A1240C97647C0932E42C0AF58CB3E2CB337C0366974C0F0C92EC0ABF284BE2A9670C038798A3E097E0FC0ACC42840DF20263F34DFAFBF04DC32C0901195BFFE08AEBFFDD1C8BFEA15B0BF10D614C0BECA903F0491FE3E625884BF35BB16C06F3112C18F4DBD3F7BEAEBBF20BF9A4036D5604034AF2340FDBCD4C02FB16840EBB722C0974872BF7729B6BE18C832C00BD93BBE117CA73F222882C053280640068A1240C97647C0932E42C0AF58CB3E2A716ABFF7338D40F0C92EC0ABF284BEE3E63D3F461D13C05D42C0C0CB928EBFF4AC7EBF930D154004DC32C0901195BFB0D19BC0D50131C0EA15B0BF10D614C063D46BC0432A12C0ADC870BF29A2823E6F3112C18F4DBD3F7BEAEBBF20BF9A4055C456BFBC2535C0DF2725C0D066D7BFD9C934C0C2F1AFBF7729B6BE18C832C06B6FB5BF03352BBFD851E7C01A5C8BC0EF888F3FAC494EC0932E42C0AF58CB3E2A716ABFF7338D40F0C92EC0ABF284BED711AAC0B107DC3FC967593F45C385C0DF20263F34DFAFBF04DC32C0901195BF1C6867C049C60B40EA15B0BF10D614C0BECA903F0491FE3EAB7CD73F2BA40B3F6F3112C18F4DBD3F55FE39C06D5261C049AA7EC06CFBDE3F5AA3BCC0C0FF27BFEBB722C0974872BF61DE6FC040C01EC065AAC63F756F67C0222882C053280640068A1240C97647C0932E42C0AF58CB3E2A716ABFF7338D408E693FC0134341C0E3E63D3F461D13C00403084068575240ED3C3FC095580CBF04DC32C0901195BF849A84C0E1978B3D0C2E19C06F45BBC0A29D69C06BE346C0AB7CD73F2BA40B3F6F3112C18F4DBD3F7BEAEBBF20BF9A40CA14FF3F4E26E9BE1C63A93F3AE947C0EBB722C0974872BF7729B6BE18C832C0D37B88C0FBFA7940222882C053280640305068C07D7AF8C0932E42C0AF58CB3E244243C00CF8CB3FF0C92EC0ABF284BE41D67CC0C504EE3F8CF86440E82AF2BFDF20263F34DFAFBF04DC32C0901195BF2E85303FF7DFB940EA15B0BF10D614C0BECA903F0491FE3EAB7CD73F2BA40B3F6F3112C18F4DBD3F7BEAEBBF20BF9A4036D5604034AF234053EA1D40C96D47C0EBB722C0974872BFC2B532C082B8CF3F5C1D86C0AED3B7C0222882C053280640DC801FBF0CA7493E932E42C0AF58CB3E2A716ABFF7338D40F0C92EC0ABF284BEE3E63D3F461D13C05887F03FBB68B340DF20263F34DFAFBFDB676AC0A55470400D8FEFBEEE33D640278300C062EC89C0E0EE68C0C78E953FAB7CD73F2BA40B3F6F3112C18F4DBD3F7BEAEBBF20BF9A4023AE943F832C92C020C32A3F1A3EE2BFEBB722C0974872BF738D88C099B633C0BC47D5BFAEF39EB9222882C0532806403728BEC0CC94A7BF932E42C0AF58CB3E2A716ABFF7338D40F0C92EC0ABF284BEE3E63D3F461D13C0B614D83F79EF4240DF20263F34DFAFBF04DC32C0901195BFDFB2BC3FE86145C0052492C0C74A4F40DC009B3E284D36BF7DCA25BF778D1F406F3112C18F4DBD3F7BEAEBBF20BF9A40632DA33FEC3D0BC053EA1D40C96D47C0EBB722C0974872BF7729B6BE18C832C06010853F0D1612BF222882C053280640BF3ECF3EA86D6DC0932E42C0AF58CB3E7BEC89C0239E593EF0C92EC0ABF284BE023F293DA1094140"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
}