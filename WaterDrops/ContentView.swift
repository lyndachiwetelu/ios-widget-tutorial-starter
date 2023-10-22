//

import SwiftUI
import WidgetKit

struct ContentView: View {
    
    @State var waterAmount: Int = 0
    @State var maxVolume = 3000
    var waterIntakePercent : Int {
        Int(CGFloat(waterAmount) / CGFloat(maxVolume) * CGFloat(100))
    }
    
    var body: some View {
        ZStack {
            Image("bg").resizable().aspectRatio(contentMode: .fill)
            
            VStack {
                Text("My Daily Hydration").font(.system(size: 22, weight: .bold)).foregroundColor(.white).padding(.bottom, 60)
                
                Text(.now, style: .date).font(.title2)
                
                BottleView(waterAmount: $waterAmount, maxVolume: $maxVolume)
                
                Text("Add or remove a 250 ml glass of water").foregroundStyle(.gray).padding()
                
                HStack {
                    Stepper(value: $waterAmount, in: 0...maxVolume, step: 250) {
                        Text("\(waterAmount) ml").foregroundColor(.black).font(.title2)
                    }.padding().frame(width: 240)
                    
                    Image(systemName: "checkmark").imageScale(.large).onTapGesture {
                        DispatchQueue.global().async {
                            LogManager.shared.saveLog(waterAmount: waterAmount)
                            WidgetCenter.shared.reloadTimelines(ofKind: "WaterWidget")
                        }
                    }
                }
                
                Text("\(waterIntakePercent) %").font(.system(size: 22, weight: .medium))
                
                Text("\(maxVolume - waterAmount) ml remaining for today").foregroundColor(.gray)
                
                
                Text("Kudos! 🎉 You are adequately hydrated for the day").foregroundColor(Color("AppColor")).padding().opacity(waterAmount == maxVolume ? 1.0 : 0)
                
            }.foregroundColor(.blue)
                .onAppear() {
                    fetchLatestLog()
                }            
        }.edgesIgnoringSafeArea(.all)
    }
    
    func fetchLatestLog() {
        DispatchQueue.global().async {
            if let latestLog = LogManager.shared.getLatestLog() {
                DispatchQueue.main.async {
                    waterAmount = Int(latestLog.amount)
                }
            }
        }
    }
    
    
}

#Preview {
    ContentView()
}

