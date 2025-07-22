interface Identity {
    id: number
    name: string
}

interface Contact {
    email: string
    phoneNumber: string
}

interface Employee extends Identity,  Contact {}