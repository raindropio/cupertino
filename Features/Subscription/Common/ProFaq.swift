import SwiftUI
import UI

struct ProFaq: View {
    var body: some View {
        DisclosureGroup("Can I use Raindrop.io for free?") {
            Text("Absolutely! Raindrop.io is completely free to use indefinitely.\n\n") +
            Text("You can use it on unlimited devices and create unlimited items and collections in all plans.")
        }
        
        DisclosureGroup("Can I collaborate with other people without paying?") {
            Text("Of course!")
        }
        
        DisclosureGroup("Do you have monthly and yearly billing options?") {
            Text("Yes! We offer either monthly or yearly billing options. The yearly billing option is always cheaper (usually ~20% discount).")
        }
        
        DisclosureGroup("What happens if I cancel my paid plan?") {
            Text("When the subscription ends you automatically switch to the free plan. All your collections (including nested) will remain accessible, you will still have an ability to add new bookmarks in it, but if you want to create more nested collections you will have to switch to paid plan.\n\n") +
            Text("Also:\n") +
            Text(" - Cloud backup will be stopped\n") +
            Text(" - New file uploads limited to 100 Mb per month\n") +
            Text(" - Permanent copies become unaccessible and could be removed in future\n") +
            Text(" - Full-text search stop working")
        }
    }
}
