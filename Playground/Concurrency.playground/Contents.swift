import UIKit

mainThread()
globalThread()
customThread()

//usarlo solo para el UI, se ejecuta secuencial
func mainThread(){
    DispatchQueue.main.async {
        for i in 0..<10{
            print("📕: \(i)")
        }
    }
}

//ejecutar tareas en background
func globalThread(){
    DispatchQueue.global(qos: .default).async {
        for i in 0..<10{
            print("📗: \(i)")
        }
    }
}

//No es tan comun hacer esto
func customThread(){
    DispatchQueue(label: "com.amjr.threads").async {
        for i in 0..<10{
            print("📘: \(i)")
        }
    }
}
