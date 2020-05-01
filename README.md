# iOS Demo Day

## Requirements

1. Fork and clone the repository
2. Create a branch for Unit1 or Unit4
3. Add your Team Name / Team Members and make a commit
4. Create a pull request (PR) and **tag your TL and Instructor**
5. **Add your presentation content**
    1. Slide deck (4 required slides)
    2. Links
    3. Answer all questions 
    4. YouTube demo video (1-2 min max)
6. Polish your Github Code repository
    1. Add screenshots and an overview to your GitHub Code Repository
    2. You should make that repository the "Public Portfolio" for your project
    3. Look at [John Sundell's Splash project](https://github.com/JohnSundell/Splash) for inspiration (code, images, GIFs)


## Links

* App Name: `<Better Professor>`
* Team: `<Chris Dobek, Lydia Zhang>`
* Github Code: `<https://github.com/Build-Week-Better-Professor-1/IOS>`
* Github Proposal: `<https://github.com/Build-Week-Better-Professor-1/IOS>`
* Trello/Github Project Kanban: `<https://trello.com/b/vASya7Xo/better-professor-bw>`
* Test Flight Signup (Recommended): `<insert beta signup link here>`
* YouTube demo video (Recommended): `<insert video url here>`

## Hero Image

`<In the folder>`

## Questions (Answer indented below)

1. What was your favorite feature to implement? Why?

`<Apply NSPredicate on fetch results for different account, and making notifications when view is poped into main scene, because it helps us pratice using concurrency and NSNotification center.>`

2. What was your #1 obstacle or bug that you fixed? How did you fix it?

`<Fixed loading info for its account using its token after sign in. >`
  
3. Share a chunk of code (or file) you're proud of and explain why.

    `<
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // transition to login view if conditions require
        let bearer = apiController.bearer
        guard bearer != nil else {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
            return
        }
        
        betterProfessorController.token = apiController.bearer
        betterProfessorController.fetchStudent { error in
            guard error == nil else {return}
            DispatchQueue.main.async {
                
                self.fetchedResultsController = {
                    let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
                    fetchRequest.predicate = NSPredicate(format:"professor == %@", bearer!)
                    let context = CoreDataStack.shared.mainContext
                    let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                         managedObjectContext: context,
                                                         sectionNameKeyPath: nil,
                                                         cacheName: nil)
                    frc.delegate = self
                    do {
                        try frc.performFetch()
                    } catch {
                        NSLog("Error doing frc fetch")
                    }
                    return frc
                } ()
                self.tableView.reloadData()
            }
        }
    }
    }
    
    This allow fetch request only occur after sign in with token, so the NSPredicate will not give us an error when poping to login page before there is a token.
  
4. What is your elevator pitch? (30 second description your Grandma or a 5-year old would understand)

`<An app that can keep a professor orgainze with students and their assigned projects. >`
  
5. What is your #1 feature?

`<Alert using notification.>`
  
6. What are you future goals?

    `<We want to integrate IOS calendar>`

## Required Slides (Add your Keynote to your PR)

1. App Name / Team Slide
2. Elevator Pitch
3. Demo
4. Future Goals

## Slide Requirements

1. 50 pt font minimum
2. Be concise — don't write sentences/paragraphs (put these in your slide notes for speaking)
3. 3-6 bullets maximum per slide
4. Do the squint test (can you read the text if you squint, if so, make the font bigger)
6. Images are always welcome
7. Do the Grandma Test (Would your Grandma understand you?)

### Optional Slides

1. Blooper: What's a funny bug or blooper? (screenshots/GIFs please)
2. Revenue Model: If the app was your sole source of income, how would you monetize it?

## Presentation Format

**7 minutes/team**

* 4 minute presentation (5 minute hard cap)
* 3 minutes of questions

We have ~12 teams presenting today — please practice your presentation with a timer (as a team), and make sure you fit within the time limit.

Plan on having one person present the slides and live demo. Please practice your presentation in front of a mirror or with your team 2-5 times. Have the app running and visible (Simulator or QuickTime) so you can quickly transition between slides and live demo.

* App Name / Team Slide (30 seconds)
* Elevator Pitch Slide (60 seconds)
* Live Demo (2 minutes)
* Future Goals (30 seconds)
* Questions (3 minutes)
