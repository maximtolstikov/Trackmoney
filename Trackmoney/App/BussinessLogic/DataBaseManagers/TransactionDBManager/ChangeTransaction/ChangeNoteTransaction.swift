import CoreData

struct ChangeNoteTransaction {
    
    /// Меняет заметку Транзакции
    static func changeNote(
        on newNote: String,
        for transaction: Transaction
        ) -> Bool {
        
        transaction.note = newNote
        
        return true
        
    }
    
}
